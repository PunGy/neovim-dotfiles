{:settings {:workingDirectories {:mode :auto}}
 :on_attach (fn [client _bufnr]
              (set client.server_capabilities.documentFormattingProvider true))}
