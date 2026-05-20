(local {: augroup} (require :utils.augroup))

(local au vim.api.nvim_create_autocmd)

;; Parsers to keep installed. Main-branch nvim-treesitter no longer accepts a
;; declarative `ensure_installed` table — install() is an imperative async call
;; we trigger once from :config.
(local ensure-installed
       [;; web
        :html
        :javascript
        :jsdoc
        :tsx
        :typescript
        :css
        :astro
        :http
        :scss
        :svelte
        ;; data formats
        :toml
        :json
        :jsonc
        :xml
        :yaml
        ;; docs
        :markdown
        :markdown_inline
        :latex
        :vimdoc
        :luadoc
        ;; languages
        :bash
        :lua
        :python
        :java
        :commonlisp
        :c
        :cmake
        :make
        :cpp
        :go
        :rust
        :sql
        :fennel
        :asm
        :haskell
        :wgsl
        ;; misc
        :diff
        :luap
        :printf
        :query
        :regex
        :vim
        :gitignore])

[{1 :nvim-treesitter/nvim-treesitter
  :branch :main
  :build ":TSUpdate"
  ;; Main branch is documented as not supporting lazy-loading.
  :lazy false
  :config (fn []
            (let [ts (require :nvim-treesitter)]
              (ts.setup)
              (ts.install ensure-installed))
            ;; Highlights are no longer auto-enabled; start treesitter per
            ;; buffer when a parser is available. pcall protects filetypes
            ;; without a registered parser.
            (au :FileType
                {:group (augroup :treesitter-start)
                 :callback (fn [args]
                             (pcall vim.treesitter.start args.buf))}))}]
