-- [nfnl] lsp/ts_ls.fnl
local function _1_(client, _bufnr)
  client.server_capabilities.documentFormattingProvider = false
  return nil
end
return {init_options = {importModuleSpecifierPreference = "relative"}, on_attach = _1_}
