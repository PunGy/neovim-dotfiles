# LIM — minimalist Neovim in Fennel

A hand-tooled IDE for Lisp-family lovers. No mason, no kitchen-sink frameworks,
no auto-everything. Each plugin earns its slot.

## Requirements

- Neovim **>= 0.12.2**
- [Fennel](https://fennel-lang.org/setup#downloading-fennel)
- A Nerd Font
- Kitty or WezTerm

## External tools

LSP servers and formatters live outside the editor (no mason). Install one you need on your own.

## Install

1. `git clone <this repo> ~/.config/nvim`
2. Install dependencies
3. `nvim`

## Philosophy

- **Minimalist.** No plugin manager UI, no installer GUI, no startup banner. We
  use Neovim, not a distro on top of it.
- **Idiomatic 0.12+.** Built-in `vim.lsp`, `vim.diagnostic`, `vim.lsp.foldexpr`,
  `vim.snippet`. Directory-based LSP configs at `lsp/<name>.lua`. We use the
  platform.
- **Fennel + nfnl.** Compile-time hygiene, runtime simplicity. Compiled `.lua`
  is committed so the repo is usable on a fresh machine without bootstrapping
  nfnl. Edit `.fnl`, the watcher rewrites the `.lua` siblings.
- **Lisp-mindset.** Small focused modules; macros (`set!`, `map!`, `plug!`,
  `plug-setup!`) for the boilerplate that would otherwise be noise; dynamic
  introspection over generated config.

## Tips

- `:Light` / `:Dark` swap modus themes at runtime. `$THEME=light nvim` boots in light.
- `<Esc><Esc>` clears search highlight (plain `<Esc>` stays untouched).
- `<C-x>q` quit, `<C-x>t` close tab, `<C-x>b` close buffer, `<C-x>s` pick session, `<C-x>l` restore last session.
- `]d`/`[d` next/prev diagnostic (from mini.bracketed); `]e`/`[e` errors only; `]w`/`[w` warnings only.
- `K` shows LSP hover with a rounded border; `<leader>cf` format; `<leader>cl` run code lens; `<leader>th` toggle inlay hints; `<leader>tl` toggle virtual-lines diagnostics.
- `q:` opens the command-line window (history of `:`-commands as a real buffer).
