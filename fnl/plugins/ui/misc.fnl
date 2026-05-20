(import-macros {: plug!} :macros.vim)

[;; Icons
 {1 :nvim-tree/nvim-web-devicons}
 {1 :echasnovski/mini.icons}
 ;; Snacks: opt-in modules only (no dashboard/explorer/notifier).
 ;; bigfile + quickfile need early load to intercept the very first BufReadPre.
 ;; image: doc.inline renders ![]() in markdown/latex; the standalone image
 ;; viewer takes over when you open a png/jpg/svg as a buffer (works with Oil
 ;; <CR>) — that path needs no extra opts, just the Kitty graphics protocol.
 {1 :folke/snacks.nvim
  :priority 1000
  :lazy false
  :opts {:bigfile {:enabled true}
         :quickfile {:enabled true}
         :image {:enabled true
                 :doc {:enabled true :inline true :float true}}}}
 ;; Menus
 {1 :folke/which-key.nvim
  :event :VeryLazy
  :opts {:preset :modern
         :spec [{1 :<leader>c :group :code}
                {1 :<leader>d :group :diagnostics}
                {1 :<leader>f :group :find}
                {1 :<leader>s :group :search}
                {1 :<leader>t :group :toggle}
                {1 :<leader>u :group :ui}
                {1 :<leader>um :group :markdown}
                {1 :<leader>v :group :vcs}
                {1 :<leader>vm :group :manage}
                {1 :<C-b> :group :buffer}
                {1 :<C-b>c :group :copy}
                {1 :<C-x> :group :exit/session}
                {1 :<localleader> :group :notes}
                {1 :<Esc><Esc> :hidden true}]}}
 ;; Misc
 {; highlight color of the
  1 :brenoprata10/nvim-highlight-colors
  :keys [[:<leader>uc #(plug! :nvim-highlight-colors :toggle)]]}
 ; Completion (snippets via built-in vim.snippet; no friendly-snippets)
 {1 :saghen/blink.cmp
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
                   :completion {:menu {:auto_show true
                                       :draw {:columns [{1 :label
                                                         2 :label_description
                                                         :gap 1}
                                                        {1 :kind_icon 2 :kind}]}}}}}}
 ; History of changes for the buffer
 {1 :mbbill/undotree
  :keys [[:<leader>h vim.cmd.UndotreeToggle :desc "Show buffer history"]]}]
