(import-macros {: plug!} :utils.vim)

[;; Icons
 {1 :nvim-tree/nvim-web-devicons}
 {1 :echasnovski/mini.icons}
 ;; Menus
 {1 :folke/which-key.nvim}
 ;; Misc
 {; highlight color of the
  1 :brenoprata10/nvim-highlight-colors
  :keys [[:<leader>uc #(plug! :nvim-highlight-colors :toggle)]]}]
