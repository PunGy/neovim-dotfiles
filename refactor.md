# LIM refactor plan — Neovim 0.12.2 migration

Target: Neovim **0.12.2**. Principles: minimalism, fine-grained control, idiomatic Vim, **no mason**.

Each phase leaves the config in a working state.

---

## Phase 0 — Prep (no behavior change)

- Bump `README.md` minimum to Neovim **0.12.2**.
- Document external tools (since no mason): `haskell-language-server-wrapper`, `typescript-language-server`, `vscode-langservers-extracted` (eslint LSP), `rust-analyzer`, `gopls`; formatters `stylua`, `fnlfmt`, `markdownlint-cli2`, `clang-format`, `cl-indentify`. A `Brewfile` or a plain `dev-tools.txt` is enough — no plugin.
- Pin `nvim-treesitter` to a known-good commit in `lazy-lock.json` before the v1 rewrite lands.
- **Remove `lua/` and `ftplugin/*.lua` from `.gitignore`** and commit the compiled output. nfnl's author recommends this — fnl→lua output is deterministic and universal; committing it removes the first-time compile pain and makes the repo usable without nfnl bootstrap.

## Phase 1 — Bug fixes and dead code

- Replace `utils/ui.fnl:close-buffer` with `echasnovski/mini.bufremove`. Delete `utils/ui.fnl` after migrating callers.
- Remove `: file-explorer` from the `(local {…} (require :utils.ui))` destructure in `keymaps.fnl:4` — it doesn't exist.
- In `utils/yndx.fnl`: either export the unused helpers (`status`, `current-branch`, `current-task`, `starts-with`) or delete them.
- Replace `utils/system.fnl:exists` with `(fn exists [p] (not= (vim.uv.fs_stat p) nil))`. Drop the `os.rename` trick.

## Phase 2 — 0.12 API migration

- `utils/navigation.fnl`: migrate from `vim.diagnostic.goto_next`/`goto_prev` (deprecated, removed in 0.12) to `vim.diagnostic.jump`:
  ```fennel
  (fn diagnostic-goto [next ?severity]
    (let [count (if next 1 -1)
          severity (when ?severity (. vim.diagnostic.severity ?severity))]
      (fn [] (vim.diagnostic.jump {: count : severity}))))
  ```
- Audit any other deprecations introduced by 0.12: `vim.lsp.get_active_clients` → `get_clients`, `vim.tbl_islist` → `vim.islist`, `vim.highlight.on_yank` → `vim.hl.on_yank`. Apply where they appear in our code or in any direct calls we add later.
- Enable `virtual_lines` in `vim.diagnostic.config` (0.11+): `:virtual_lines {:current_line true}`. Nicer than `virtual_text` for long messages.

## Phase 3 — Macro layer rebuild

- **Rewrite `map!`** to accept an options table so `vcs.fnl` no longer needs to shadow it:
  ```fennel
  (fn map! [mode lhs rhs ?opts]
    `(vim.keymap.set ,(split-modes mode) ,lhs ,rhs ,(or ?opts {})))
  ```
  Callers: `(map! :n :<C-s> (cmd$ :w) {:desc "Save" :silent true})`. The local `map!` shadow in `vcs.fnl` is then deleted.
- **Rename `plug!` → `plug-setup!`** and narrow its purpose to one thing: `(plug-setup! :foo {:x 1})` → `((. (require :foo) :setup) {:x 1})`. Drop the chameleon "either string or table" branch.
- Move `cmd$`/`term$` from `macros/exec.fnl` to `utils/` as plain functions. They aren't macros (no AST manipulation), they build strings. Drop the `$` suffix → `cmd`, `term-cmd`.

## Phase 4 — LSP, idiomatic and native

Neovim 0.11+ supports directory-based LSP config: drop one file per server under `lsp/<name>.lua` (or `lsp/<name>.fnl` compiled to lua) at runtimepath root, then `vim.lsp.enable({...})`. Cleaner than the configs-table and aligns with "fine-grained control."

- Create `fnl/lsp/hls.fnl`, `ts_ls.fnl`, `eslint.fnl`, `rust_analyzer.fnl`, `gopls.fnl`. Each returns the server's table.
- `plugins/coding/lsp.fnl` collapses to defaults + `(vim.lsp.enable [:hls :ts_ls :eslint :rust_analyzer :gopls])`.
- **Wire blink.cmp capabilities** for every server: set globally with `(vim.lsp.config "*" {:capabilities (.. blink-caps)})` once at startup, so per-server files stay minimal.
- Keep `nvim-lspconfig` for sane defaults for now; it can be dropped later by providing `cmd`/`root_markers`/`filetypes` ourselves.

## Phase 5 — Autocmds layer (the missing module)

New `fnl/autocmds.fnl`, required from `config.fnl`. Add a small `utils/augroup.fnl` helper.

- `TextYankPost` → `vim.hl.on_yank`.
- `LspAttach` → buffer-local maps:
  - `K` → `vim.lsp.buf.hover`
  - 0.11 defaults `grn`/`gra`/`grr`/`gri` are kept implicitly.
  - `<leader>cf` → format current buffer (conform first, else `vim.lsp.buf.format`).
  - `<leader>th` → toggle inlay hints (`vim.lsp.inlay_hint.enable`).
  - `<leader>tl` → toggle `virtual_lines` diagnostics.
- `BufReadPost` → restore last cursor position (6-line snippet, no plugin).
- `FileType {fennel,lisp}` → `lispwords`/`iskeyword` tweaks.
- **No format-on-save.** Formatting stays manual via `<C-f>` (existing) and the new `<leader>cf` (LspAttach).

## Phase 6 — Plugin spec hygiene

- Normalize every plugin file to return a vector (even single-plugin). Fix `notes.fnl`, `vcs.fnl`.
- Resolve `:lazy false` + `:keys`/`:event` contradictions:
  - `persistence.nvim`: drop `:lazy false`, rely on `:keys`.
  - `treesitter.fnl`: drop `:event` (keep `:lazy false` — TS highlighting must boot on first paint).
- Add `which-key.nvim` group registrations: `<leader>v` vcs, `<leader>f` find, `<leader>s` search, `<leader>u` ui, `<leader>d` diagnostics, `<C-b>` buffer, `<C-x>` exit/session.
- Drop `rafamadriz/friendly-snippets` (see Phase 8 — switching to `vim.snippet`).

## Phase 7 — Keymap polish

- `<Esc>` → `<Esc><Esc>` for `:nohlsearch`. Plain `<Esc>` untouched (avoids terminal/plugin friction).
- Restore vim's `<C-a>` (increment). Move "select all" to `<leader>a`.
- `<C-p>` paste-from-clipboard stays for now; document it.
- Delete the local `map!` shadow in `vcs.fnl` (was needed only for `silent`/`buffer` defaults).
- `<C-Tab>` close-tab: keep, but add `<leader>tq` fallback for SSH-into-tmux sessions.

## Phase 8 — Idiomatic additions (minimalist)

- **`mini.ai`** — better in/around text objects (`vif`, `vic`, …).
- **`mini.bufremove`** — replaces deleted `close-buffer`.
- **`mini.bracketed`** — consolidates `]x`/`[x` motions. Replaces the `diagnostic-goto` factory.
- **`nvim-treesitter-textobjects`** — `daf`/`vif`/`gnf`, pairs with mini.ai.
- **`vim.snippet`** — built-in (0.10+). Drop `friendly-snippets`; rely on LSP-provided snippets through blink.cmp.
- **Keep `nvim-surround`** (don't add `mini.surround`).
- **Snacks modules** (modular, only what we want):
  - `snacks.bigfile` — disables expensive features on huge files.
  - `snacks.quickfile` — faster first-paint on `nvim <file>`.
  - `snacks.image` — inline image rendering for markdown/latex/html via Kitty graphics protocol. Works on Kitty/WezTerm. Preferred over `3rd/image.nvim` because it lives in a framework we're already taking, and needs no ImageMagick dep.
- **Inlay-hint toggle** and **virtual_lines toggle** (wired in Phase 5 LspAttach).
- **`:Light`/`:Dark` user commands** to swap modus-themes at runtime — replaces the brittle `vim.env.THEME` check.

## Phase 9 — Documentation

Update `README.md`:
- Min Neovim **0.12.2**.
- External tools list (LSPs + formatters) with one-line install commands per OS.
- Short "philosophy" paragraph (minimalism / no mason / fine-grained / committed-lua).
- One-paragraph map of the directory layout.

---

## Deferred decisions

- **`vim.pack`** (native plugin manager, new in 0.12). Real, but blocker: no lock file → no reproducible installs across machines. Also missing: event/cmd/keys lazy-loading, `:opts_extend`, UI. Revisit ~6 months after 0.12.2 ships, or when 0.13 lands. Stay on `lazy.nvim` until then.
- **Dropping `nvim-lspconfig`** entirely. Possible once we provide `cmd`/`root_markers`/`filetypes` per server. Deferred until after Phase 4 stabilizes.

## Execution order

1. Phase 1 (bug fixes) + Phase 2 (0.12 API + .gitignore) — one PR. Required before upgrading nvim.
2. Phase 3 (macros) — unlocks clean LspAttach in Phase 5.
3. Phase 4 (LSP) + Phase 5 (autocmds) — biggest maturity gain, do together.
4. Phase 6 (plugin hygiene) + Phase 7 (keymaps).
5. Phase 8 — pick incrementally; not one PR.
6. Phase 9 — last.

## Pushbacks recorded

- No format-on-save (confirmed). Manual via `<C-f>` and `<leader>cf` only.
- Keep `lua/` + `ftplugin/*.lua` committed (un-gitignore).
- `plug-setup!` retained, narrowed.
- `nvim-surround` kept over `mini.surround`.
- `<C-a>` → `<leader>a` for select all; vim's increment restored.
