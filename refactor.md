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

- Create `lsp/hls.fnl`, `ts_ls.fnl`, `eslint.fnl`, `rust_analyzer.fnl`, `gopls.fnl`. Each returns the server's table; empty `{}` is a valid "I own this server, use lspconfig defaults" marker.
- `plugins/coding/lsp.fnl` collapses to defaults + `(vim.lsp.enable [:hls :ts_ls :eslint :rust_analyzer :gopls])`.
- **`:lazy false`, not `:event`.** `vim.lsp.enable` registers a `FileType` autocmd internally. If lspconfig lazy-loads on `BufReadPost`, the triggering buffer has already loaded and the autocmd registers too late for that buffer's first attach. Drop `:event` and `vim.schedule_wrap`; let it load at startup (the spec is just a defaults registry — startup cost is negligible).
- **Wire blink.cmp capabilities** for every server: set globally with `(vim.lsp.config "*" {:capabilities (blink.get_lsp_capabilities)})` once at startup, so per-server files stay minimal.
- Diagnostic float gets `:border :rounded`.
- Keep `nvim-lspconfig` for sane defaults for now; it can be dropped later by providing `cmd`/`root_markers`/`filetypes` ourselves.

## Phase 5 — Autocmds layer (the missing module)

New `fnl/autocmds.fnl`, required from `config.fnl`. Add a small `utils/augroup.fnl` helper.

- `TextYankPost` → `vim.hl.on_yank`.
- `LspAttach` → buffer-local maps:
  - `K` → `vim.lsp.buf.hover {:border :rounded}` (overrides 0.11 default).
  - 0.11 defaults `grn`/`gra`/`grr`/`gri` are kept implicitly.
  - `<leader>cf` → `conform.format {:lsp_fallback true}` (one call; no pcall dance).
  - `<leader>cl` → `vim.lsp.codelens.run`.
  - `<leader>th` → toggle inlay hints (`vim.lsp.inlay_hint.enable`).
  - `<leader>tl` → toggle `virtual_lines` diagnostics.
  - If server supports `textDocument/foldingRange`: set `foldexpr = v:lua.vim.lsp.foldexpr()` / `foldmethod = expr` (outline-mode style folding).
- One global autocmd refreshes codelens on `BufEnter`/`CursorHold`/`InsertLeave` for buffers whose attached clients advertise `textDocument/codeLens`.
- `BufReadPost` → restore last cursor position (6-line snippet, no plugin).
- `FileType {fennel,lisp}` → `lispwords`/`iskeyword` tweaks.
- **No format-on-save.** Formatting stays manual via `<C-f>` (existing) and the new `<leader>cf` (LspAttach).

## Phase 6 — Plugin spec hygiene

- Normalize every plugin file to return a vector (even single-plugin). Fix `notes.fnl`, `vcs.fnl`, **`coding/formatting.fnl`** (also a bare table).
- Resolve `:lazy false` + `:keys`/`:event` contradictions:
  - **`persistence.nvim`: must KEEP `:lazy false`** — its `setup()` registers the `VimLeavePre` autocmd that saves the session on exit. Lazy-on-keys defers setup past every exit, silently breaking "restore last session". The plan was wrong on this one.
  - `treesitter.fnl`: no `:event` to drop (current spec is `:lazy false` only). Skip.
- Also fix the `#{...}` (Fennel set literal) in persistence opts — must be `{...}` (table). The `dir`/`need` opts were silently ignored before.
- Add `which-key.nvim` v3 group registrations via `:opts.spec`:
  - `<leader>c` code, `<leader>d` diagnostics, `<leader>f` find, `<leader>s` search, `<leader>t` toggle, `<leader>u` ui (+ `um` markdown), `<leader>v` vcs (+ `vm` manage), `<C-b>` buffer (+ `c` copy), `<C-x>` exit/session, `<localleader>` notes.
- Drop `rafamadriz/friendly-snippets` (Phase 8 — switching to `vim.snippet`). Blink.cmp 1.x uses `vim.snippet` by default.

## Phase 7 — Keymap polish

- `<Esc>` → `<Esc><Esc>` for `:nohlsearch`. Plain `<Esc>` untouched (avoids terminal/plugin friction).
- Restore vim's `<C-a>` (increment). Move "select all" to `<leader>a`.
- `<C-p>` paste-from-clipboard stays for now; document it.
- Delete the local `map!` shadow in `vcs.fnl` (was needed only for `silent`/`buffer` defaults). — *done in Phase 3.*
- `<C-Tab>` close-tab: keep, add **`<C-x>t`** fallback for SSH-into-tmux sessions. (Originally planned as `<leader>tq`, but `<leader>t` is the *toggle* group; close-tab fits better under the `<C-x>` exit/session group.)
- **Buffer close moves to `<C-x>b`** (was `<C-b>q`). `<C-x>` becomes the universal close/exit prefix (`<C-x>q` quit, `<C-x>t` close tab, `<C-x>b` close buffer); `<C-b>` keeps only buffer-info ops (`cn`/`cp`/`o`).
- **Which-key popup is suppressed while `<Esc>` is waiting** for its second press, via which-key v3's `defer` callback returning true when `ctx.keys == "<Esc>"`. Plain `<Esc>` keeps feeling instant; the `<Esc><Esc>` chain still resolves to `:noh`.
- **Macros over raw require:** every `((. (require :X) :Y) args)` is now `(plug! :X :Y args)` or `(plug-setup! :X opts)`. Applied across `autocmds.fnl`, `plugins/coding/formatting.fnl`, `plugins/coding/misc.fnl`, `plugins/treesitter.fnl`.

## Phase 8 — Idiomatic additions (minimalist)

- **`mini.ai`** — `af`/`if` function, `ac`/`ic` class, `ao`/`io` block/conditional/loop via `gen_spec.treesitter`. Lives in `plugins/coding/misc.fnl`.
- **`mini.bufremove`** — replaces deleted `close-buffer`. Now bound to `<C-x>b`.
- **`mini.bracketed`** — *promoted into Phase 4 work*. Consolidates `]x`/`[x` motions; replaces the `diagnostic-goto` factory and `utils/navigation.fnl`. Only severity-filtered jumps (`]e`/`]w`) stay as explicit `vim.diagnostic.jump` calls in `keymaps.fnl`. Disabled categories that clash with Vim/gitsigns: `file`, `indent`, `undo`.
- **`nvim-treesitter-textobjects`** — installed as a dependency of `mini.ai` purely for the `queries/<lang>/textobjects.scm` files. No keymaps wired on its own (mini.ai owns selection; mini.bracketed owns generic node motion).
- **`vim.snippet`** — built-in (0.10+). Dropped `friendly-snippets`; blink.cmp 1.x uses `vim.snippet` by default.
- **Keep `nvim-surround`** (don't add `mini.surround`).
- **Snacks modules** — opt-in only, no kitchen-sink:
  - `snacks.bigfile` — disables expensive features on huge files.
  - `snacks.quickfile` — faster first-paint on `nvim <file>`.
  - `snacks.image` — inline images via Kitty graphics protocol; no ImageMagick dep. Works on Kitty/WezTerm.
  - Loaded with `:lazy false :priority 1000` so bigfile/quickfile can intercept the very first `BufReadPre`.
- **Inlay-hint toggle** and **virtual_lines toggle** (wired in Phase 5 LspAttach).
- **`:Light`/`:Dark` user commands** — defined in `ui/theme.fnl`. Set `vim.o.background` and call `colorscheme`. Boot still consults `vim.env.THEME` (light → `:Light`, anything else → `:Dark`), but the env check is no longer load-bearing — it's just a default. Runtime swap costs zero plugin reload.

## Phase 9 — Documentation

Update `README.md`:
- Min Neovim **0.12.2**.
- External tools list (LSPs + formatters) with one-line install commands per OS.
- Short "philosophy" paragraph (minimalism / no mason / fine-grained / committed-lua).
- One-paragraph map of the directory layout.

---

## Emacs-flavored additions

Pulled from Emacs muscle memory. Each one is built into Neovim 0.11+/0.12; no third-party dep.

- **Outline-mode style folding** — in `LspAttach`, when the server supports `textDocument/foldingRange`, set `foldexpr = v:lua.vim.lsp.foldexpr()` and `foldmethod = expr`. Gives `zM`/`zR`/`za` semantic folding for free, per buffer.
- **Eldoc-style hover** — override `K` to `vim.lsp.buf.hover {:border :rounded}` in `LspAttach`. Cleaner popup, closer to `eldoc-mode`.
- **Code lenses** — refresh on `BufEnter`/`CursorHold`/`InsertLeave` filtered by client method support; `<leader>cl` → `vim.lsp.codelens.run`. Replicates Emacs's `lsp-lens-mode` (test/run/references inline).
- **Diagnostic float border** — `:float {:border :rounded :source :if_many}` in `vim.diagnostic.config`.
- **Conform's built-in LSP fallback** — replace the `(pcall require :conform)` + formatter-list dance in `<leader>cf` with `conform.format {:bufnr bufnr :lsp_fallback true}`. One call, conform does the dispatch.
- **`mini.bracketed`** (was Phase 8) — Emacs `next-error`/`previous-error`-style navigation, generalized: `]b`/`[b` buffers, `]d`/`[d` diagnostics, `]c`/`[c` comments, `]q`/`[q` quickfix, `]j`/`[j` jumplist, `]n`/`[n` treesitter nodes, `]y`/`[y` yank rotation, etc. Kills the `diagnostic-goto` factory and the whole `utils/navigation.fnl` module.

Still candidate, not yet implemented:
- **`vim.lsp.completion.enable`** — 0.12's native completion engine. Skipped because we already use `blink.cmp`. Worth revisiting only if `blink` becomes a maintenance burden.
- **`:Inspect` / `:InspectTree` keymap** (`<leader>uI`?) — treesitter/highlight inspector, very `describe-thing-at-point`-y.
- **`q:` command-line window** — already built-in, just worth surfacing in `which-key` doc.

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
