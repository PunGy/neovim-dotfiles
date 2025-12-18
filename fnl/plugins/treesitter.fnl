[{1 :nvim-treesitter/nvim-treesitter
  :build ":TSUpdate"
  :cmd [:TSUpdateSync :TSUpdate :TSInstall]
  :lazy false
  :event [:BufReadPost :BufWritePost :BufNewFile :VeryLazy]
  :config (fn [_ opts]
            ((. (require :nvim-treesitter.configs) :setup) opts)
            (let [parser-config ((. (require :nvim-treesitter.parsers)
                                    :get_parser_configs))
                  shik-parser-path (vim.fn.expand "~/Develop/shik/docs/treesitter")]

              (vim.filetype.add {:extension {:shk :shik}})
              (let [rtp (vim.api.nvim_get_option :runtimepath)]
                (vim.api.nvim_set_option :runtimepath
                                         (.. rtp "," shik-parser-path)))

              (tset parser-config :shik
                    {:install_info {:url shik-parser-path
                                    :files [:src/parser.c]
                                    :generate_requires_npm false
                                    :requires_generate_from_grammar false}
                     :filetype :shik})))
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
                            :shik
                            :gitignore]
         :highlight {:enable true}
         :indent {:enable true}}
  :opts_extend [:ensure_installed]
  :version false}]
