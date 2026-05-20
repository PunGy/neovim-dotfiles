{:init_options {:importModuleSpecifierPreference :relative}
 :on_attach (fn [client _bufnr]
              (set client.server_capabilities.documentFormattingProvider false))}
