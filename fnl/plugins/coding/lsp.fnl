(local servers [:hls :ts_ls :eslint :rust_analyzer :gopls])

(local diagnostics-ui {:severity_sort true
                       :signs {:text [" " " " " " " "]}
                       :underline true
                       :update_in_insert false
                       :virtual_lines {:current_line true}
                       :virtual_text {:prefix "●"
                                      :source :if_many
                                      :spacing 4}
                       :float {:border :rounded :source :if_many}})

(fn on-startup []
  (let [blink (require :blink.cmp)]
    (vim.lsp.config "*" {:capabilities (blink.get_lsp_capabilities)}))
  (vim.diagnostic.config diagnostics-ui)
  (vim.lsp.enable servers))

[{1 :neovim/nvim-lspconfig
  :dependencies [:saghen/blink.cmp]
  :lazy false
  :config on-startup}]
