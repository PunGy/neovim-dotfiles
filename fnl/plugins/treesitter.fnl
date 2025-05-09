(fn dedup [list]
  (let [ret {}
        seen {}]
    (each [_ v (ipairs list)]
      (when (not (. seen v)) (table.insert ret v) (tset seen v true)))
    ret))

[{1 :nvim-treesitter/nvim-treesitter
  :build ":TSUpdate"
  :cmd [:TSUpdateSync :TSUpdate :TSInstall]
  :config (fn [_ opts]
            (when (= (type opts.ensure_installed) :table)
              (set opts.ensure_installed (dedup opts.ensure_installed)))
            ((. (require :nvim-treesitter.configs) :setup) opts))
  :event [:BufReadPost :BufWritePost :BufNewFile :VeryLazy]
  :init (fn [plugin]
          ((. (require :lazy.core.loader) :add_to_rtp) plugin)
          (require :nvim-treesitter.query_predicates))
  ;:keys [{1 :<c-space> :desc "Increment Selection"}
  ;       {1 :<bs> :desc "Decrement Selection" :mode :x}]
  :lazy (= (vim.fn.argc (- 1)) 0)
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
                            ;; Misc
                            :diff
                            :luap
                            :printf
                            :query
                            :regex
                            :vim
                            :gitignore]
         :highlight {:enable true}
         :incremental_selection {:enable true
                                 :keymaps {:init_selection :<C-space>
                                           :node_decremental :<bs>
                                           :node_incremental :<C-space>
                                           :scope_incremental false}}
         :indent {:enable true}
         :textobjects {:move {:enable true
                              :goto_next_end {"]A" "@parameter.inner"
                                              "]C" "@class.outer"
                                              "]F" "@function.outer"}
                              :goto_next_start {"]a" "@parameter.inner"
                                                "]c" "@class.outer"
                                                "]f" "@function.outer"}
                              :goto_previous_end {"[A" "@parameter.inner"
                                                  "[C" "@class.outer"
                                                  "[F" "@function.outer"}
                              :goto_previous_start {"[a" "@parameter.inner"
                                                    "[c" "@class.outer"
                                                    "[f" "@function.outer"}}}}
  :opts_extend [:ensure_installed]
  :version false}]
