-- [nfnl] lsp/eslint.fnl
local function _1_(client, _bufnr)
  client.server_capabilities.documentFormattingProvider = true
  return nil
end
return {settings = {workingDirectories = {mode = "auto"}}, on_attach = _1_}
