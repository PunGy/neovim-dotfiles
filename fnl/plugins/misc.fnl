(import-macros {: plug!} :macros.vim)

[{; Must be :lazy false — persistence registers its VimLeavePre save-hook
  ; inside setup(); lazy-on-keys would defer setup past every exit.
  1 :folke/persistence.nvim
  :lazy false
  :keys [{1 :<C-x>l
          2 #(plug! :persistence :load {:last true})
          :desc "Restore last session"}
         {1 :<C-x>s
          2 #(plug! :persistence :select)
          :desc "Select session"}]
  :opts {:dir (.. (vim.fn.stdpath :state) :/sessions/) :need 0}}
 {1 :echasnovski/mini.bufremove
  :keys [{1 :<C-x>b
          2 #(plug! :mini.bufremove :delete 0 false)
          :desc "Close buffer"}]}
 {1 :echasnovski/mini.bracketed
  :event :BufReadPost
  :opts {:buffer {:suffix :b}
         :comment {:suffix :c}
         :conflict {:suffix :x}
         :diagnostic {:suffix :d}
         :file {:suffix ""}
         :indent {:suffix ""}
         :jump {:suffix :j}
         :location {:suffix :l}
         :oldfile {:suffix :o}
         :quickfix {:suffix :q}
         :treesitter {:suffix :n}
         :undo {:suffix ""}
         :window {:suffix :w}
         :yank {:suffix :y}}}]
