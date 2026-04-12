;; Servers

(local configs
       {:hls {:cmd [:haskell-language-server-wrapper]
              :filetypes [:haskell]
              :settings {:haskell {:formattingProvider :fourmolu}}}
        :eslint {:settings {:workingDirectories {:mode :auto}}
                 :on_attach (fn [client]
                              (set client.server_capabilities.documentFormattingProvider
                                   true))}
        :ts_ls {:on_attach (fn [client]
                             (set client.server_capabilities.documentFormattingProvider
                                  false))
                :init_options {:importModuleSpecifierPreference :relative}}
        :gopls {}})

(local servers [:hls :ts_ls :eslint :rust_analyzer :gopls])

;; Config

(local diagnostics-ui {:severity_sort true
                       :signs {:text [" " " " " " " "]}
                       :underline true
                       :update_in_insert false
                       :virtual_text {:prefix "●"
                                      :source :if_many
                                      :spacing 4}})

;; Setup

(fn on-startup []
  (each [server config (pairs configs)]
    (vim.lsp.config server config))
  (vim.diagnostic.config (vim.deepcopy diagnostics-ui))
  (vim.lsp.enable servers))

[{1 :neovim/nvim-lspconfig
  :event [:BufReadPost :BufWritePost :BufNewFile]
  :config (vim.schedule_wrap on-startup)}]
