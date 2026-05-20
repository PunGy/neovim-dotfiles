-- [nfnl] fnl/plugins/coding/formatting.fnl
local function _1_()
  local buf = vim.api.nvim_get_current_buf()
  local conform = require("conform")
  if (next(conform.list_formatters()) == nil) then
    return vim.lsp.buf.format()
  else
    return conform.format({bufnr = buf})
  end
end
return {"stevearc/conform.nvim", keys = {{"<C-f>", _1_}}, opts = {formatters = {["cl-indentify"] = {command = "cl-indentify", args = {"-r"}}}, formatters_by_ft = {fennel = {"fnlfmt"}, lisp = {"cl-indentify"}, lua = {"stylua"}, c = {"clang_format"}, cpp = {"clang_format"}, markdown = {"markdownlint-cli2"}}}}
