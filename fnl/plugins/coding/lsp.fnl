(local servers [])

[{1 :neovim/nvim-lspconfig
  :event [:BufReadPost :BufWritePost :BufNewFile]
  :opts {:diagnostics {:severity_sort true
                       :signs {:text [" " " " " " " "]}
                       :underline true
                       :update_in_insert false
                       :virtual_text {:prefix "●"
                                      :source :if_many
                                      :spacing 4}}
         :servers {:eslint {:settings {:workingDirectories {:mode :auto}}
                            :on_attach (fn [client]
                                         (set client.server_capabilities.documentFormattingProvider
                                              true))}
                   :ts_ls {:on_attach (fn [client]
                                        (set client.server_capabilities.documentFormattingProvider
                                             false))
                           :init_options {:importModuleSpecifierPreference :relative}}
                   :neocmake {}
                   :clangd {:cmd [:clangd :--background-index :--clang-tidy]}
                   :marksman {:on_attach (fn [client]
                                           (if (pcall require :zk)
                                               (client.stop)))}
                   :hls {:settings {:haskell {:formattingProvider :fourmolu}}}}}
  :config (vim.schedule_wrap (fn [_ opts]
                               (vim.diagnostic.config (vim.deepcopy opts.diagnostics))
                               (vim.lsp.config :hls
                                               {:cmd [:haskell-language-server-wrapper]
                                                :filetypes [:hs]
                                                :settings {:haskell {:formattingProvider :fourmolu}}})

                               (vim.lsp.enable [:hls :ts_ls])))}]
