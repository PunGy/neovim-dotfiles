-- [nfnl] fnl/plugins/coding/lsp.fnl
local servers = {"hls", "ts_ls", "eslint", "rust_analyzer", "gopls"}
local diagnostics_ui = {severity_sort = true, signs = {text = {" ", " ", " ", " "}}, underline = true, virtual_lines = {current_line = true}, virtual_text = {prefix = "\226\151\143", source = "if_many", spacing = 4}, float = {border = "rounded", source = "if_many"}, update_in_insert = false}
local function on_startup()
  do
    local blink = require("blink.cmp")
    vim.lsp.config("*", {capabilities = blink.get_lsp_capabilities()})
  end
  vim.diagnostic.config(diagnostics_ui)
  return vim.lsp.enable(servers)
end
return {{"neovim/nvim-lspconfig", dependencies = {"saghen/blink.cmp"}, config = on_startup, lazy = false}}
