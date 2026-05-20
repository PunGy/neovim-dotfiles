-- [nfnl] fnl/plugins/coding/formatting.fnl
local function _1_()
  return require("conform").format({lsp_fallback = true})
end
return {{"stevearc/conform.nvim", keys = {{"<C-f>", _1_, desc = "Format buffer"}}, opts = {formatters = {["cl-indentify"] = {command = "cl-indentify", args = {"-r"}}}, formatters_by_ft = {fennel = {"fnlfmt"}, lisp = {"cl-indentify"}, lua = {"stylua"}, c = {"clang_format"}, cpp = {"clang_format"}, markdown = {"markdownlint-cli2"}}}}}
