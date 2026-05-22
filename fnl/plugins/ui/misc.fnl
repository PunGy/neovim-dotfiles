(import-macros {: plug!} :macros.vim)
(fn render-blink-text [ctx]
  (let [item ctx.item
        ld (or item.labelDetails {})]
    (or (and (= (type ld.description) :string) ld.description)
        (and (= (type ld.detail) :string) ld.detail)
        (and (= (type item.detail) :string) item.detail) "")))

[;; Icons
 {1 :nvim-tree/nvim-web-devicons}
 {1 :echasnovski/mini.icons}
 ;; bigfile + quickfile need early load to intercept the very first BufReadPre.
 {1 :folke/snacks.nvim
  :priority 1000
  :lazy false
  :opts {:bigfile {:enabled true}
         :quickfile {:enabled true}
         :image {:enabled true :doc {:enabled true :inline true :float true}}}}
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
  :keys [{1 :<leader>uc
          2 #(plug! :nvim-highlight-colors :toggle)
          :desc "Toggle color highlights"}]}
 ; Completion (snippets via built-in vim.snippet; no friendly-snippets)
 {1 :saghen/blink.cmp
  :version :1.*
  :opts {:keymap {:preset :none
                  :<C-e> [:hide :fallback]
                  :<C-n> [:select_next]
                  :<C-p> [:select_prev]
                  :<M-k> [:show_documentation :hide_documentation]
                  :<C-Enter> [:select_and_accept]}
         :completion {:menu {:draw {:components {:label_description {:width {:max 60}
                                                                     :text render-blink-text}}
                                    :columns [{1 :label 2 :label_description :gap 1}
                                              {1 :kind_icon 2 :kind}]}}}
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
  :keys [{1 :<leader>h 2 vim.cmd.UndotreeToggle :desc "Show buffer history"}]}]
