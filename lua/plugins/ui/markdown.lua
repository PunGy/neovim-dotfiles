-- [nfnl] fnl/plugins/ui/markdown.fnl
local _local_1_ = require("utils.exec")
local cmd = _local_1_.cmd
local function _2_()
  vim.g.mkdp_filetypes = {"markdown"}
  return nil
end
return {{"iamcco/markdown-preview.nvim", cmd = {"MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"}, keys = {{"<leader>ump", cmd("MarkdownPreview"), "desc", "Start markdown preview"}, {"<leader>umt", cmd("MarkdownPreviewToggle"), "desc", "Toggle markdown preview"}, {"<leader>ums", cmd("MarkdownPreviewStop"), "desc", "Stop markdown preview"}}, ft = {"markdown"}, init = _2_, build = "cd app && yarn install"}}
