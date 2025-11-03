(import-macros {: plug!} :macros.vim)

[{1 :folke/persistence.nvim
  :lazy false
  :keys [[:<C-x>l
          #(plug! :persistence :load {:last true})
          :desc
          "Restore last session"]
         [:<C-x>s #(plug! :persistence :select)]]
  :opts #{:dir (.. (vim.fn.stdpath :state) :/sessions/) :need 0}}]
