(import-macros {: map!} :hibiscus.vim)

[{1 :folke/persistence.nvim
  :event :BufReadPre
  :lazy false
  :opts (fn []
          {:dir (.. (vim.fn.stdpath :state) :/sessions/) :need 0})}]
