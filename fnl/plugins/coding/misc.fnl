(import-macros {: cmd$} :macros.exec)

[{1 :AndrewRadev/switch.vim}
 {1 :kylechui/nvim-surround
  :event :VeryLazy
  :config (fn []
            ((. (require :nvim-surround) :setup)))}]
