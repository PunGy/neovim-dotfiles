(import-macros {: cmd$} :macros.exec)

[{1 :AndrewRadev/switch.vim
  :init (fn []
          (local aug (vim.api.nvim_create_augroup :Switch {:clear true}))
          (vim.api.nvim_create_autocmd :FileType
                                       {:callback #(set vim.b.switch_custom_definitions
                                                        [vim.g.switch_builtins.javascript_string_style])
                                        :group aug
                                        :pattern :typescript}))}]
