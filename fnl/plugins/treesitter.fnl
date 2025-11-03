[{1 :nvim-treesitter/nvim-treesitter
  :build ":TSUpdate"
  :cmd [:TSUpdateSync :TSUpdate :TSInstall]
  :lazy false
  :event [:BufReadPost :BufWritePost :BufNewFile :VeryLazy]
  :config (fn [_ opts]
            ((. (require :nvim-treesitter.configs) :setup) opts))
  :init (fn [plugin]
          ((. (require :lazy.core.loader) :add_to_rtp) plugin)
          (require :nvim-treesitter.query_predicates))
  :opts {:ensure_installed [;; web
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
                            ;; Languages
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
                            ;; Misc
                            :diff
                            :luap
                            :printf
                            :query
                            :regex
                            :vim
                            :gitignore]
         :highlight {:enable true}
         :indent {:enable true}}
  :opts_extend [:ensure_installed]
  :version false}]
