(import-macros {: plug!} :macros.vim)

[;; Icons
 {1 :nvim-tree/nvim-web-devicons}
 {1 :echasnovski/mini.icons}
 ;; Menus
 {1 :folke/which-key.nvim}
 ;; Misc
 {; highlight color of the
  1 :brenoprata10/nvim-highlight-colors
  :keys [[:<leader>uc #(plug! :nvim-highlight-colors :toggle)]]}
 ; Completion
 {1 :saghen/blink.cmp
  :dependencies [:rafamadriz/friendly-snippets]
  :version :1.*
  :opts {:keymap {:preset :none
                  :<C-e> [:hide :fallback]
                  :<C-n> [:select_next]
                  :<C-p> [:select_prev]
                  :<M-k> [:show_documentation :hide_documentation]
                  :<C-Enter> [:select_and_accept]}
         :cmdline {:enabled true
                   :keymap {:preset :inherit
                            :<M-Enter> [:select_accept_and_enter]}
                   :completion {:menu {:auto_show true}}}}}
 ; History of changes for the buffer
 {1 :mbbill/undotree
  :keys [[:<leader>h vim.cmd.UndotreeToggle :desc "Show buffer history"]]}]
