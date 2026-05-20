-- [nfnl] fnl/plugins/coding/lsp.fnl
local configs
local function _1_(client)
  client.server_capabilities.documentFormattingProvider = true
  return nil
end
local function _2_(client)
  client.server_capabilities.documentFormattingProvider = false
  return nil
end
configs = {hls = {cmd = {"haskell-language-server-wrapper"}, filetypes = {"haskell"}, settings = {haskell = {formattingProvider = "fourmolu"}}}, eslint = {settings = {workingDirectories = {mode = "auto"}}, on_attach = _1_}, ts_ls = {on_attach = _2_, init_options = {importModuleSpecifierPreference = "relative"}}, gopls = {}}
local servers = {"hls", "ts_ls", "eslint", "rust_analyzer", "gopls"}
local diagnostics_ui = {severity_sort = true, signs = {text = {"\239\129\151 ", "\239\131\171 ", "\239\129\154 ", "\239\129\177 "}}, underline = true, virtual_lines = {current_line = true}, virtual_text = {prefix = "\226\151\143", source = "if_many", spacing = 4}, update_in_insert = false}
local function on_startup()
  for server, config in pairs(configs) do
    vim.lsp.config(server, config)
  end
  vim.diagnostic.config(vim.deepcopy(diagnostics_ui))
  return vim.lsp.enable(servers)
end
return {{"neovim/nvim-lspconfig", event = {"BufReadPost", "BufWritePost", "BufNewFile"}, config = vim.schedule_wrap(on_startup)}}
