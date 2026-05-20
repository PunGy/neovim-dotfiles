(import-macros {: plug-setup!} :macros.vim)

[{1 :AndrewRadev/switch.vim}
 {1 :kylechui/nvim-surround
  :event :VeryLazy
  :config (fn [] (plug-setup! :nvim-surround))}
 ;; Treesitter text-object queries (@function.outer etc.). No keymaps here —
 ;; mini.ai owns selection; mini.bracketed owns generic node motion.
 {1 :nvim-treesitter/nvim-treesitter-textobjects
  :dependencies [:nvim-treesitter/nvim-treesitter]
  :event :VeryLazy}
 {1 :echasnovski/mini.ai
  :event :VeryLazy
  :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
  :opts (fn []
          (let [ai (require :mini.ai)
                ts ai.gen_spec.treesitter]
            {:n_lines 500
             :custom_textobjects
             {:f (ts {:a :@function.outer :i :@function.inner})
              :c (ts {:a :@class.outer :i :@class.inner})
              :o (ts {:a [:@block.outer :@conditional.outer :@loop.outer]
                      :i [:@block.inner :@conditional.inner :@loop.inner]})}}))}]
