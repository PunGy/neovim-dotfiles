-- [nfnl] fnl/plugins/ui/markdown.fnl
local function _1_()
  vim.g.mkdp_filetypes = {"markdown"}
  return nil
end
return {{"iamcco/markdown-preview.nvim", cmd = {"MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop"}, keys = {{"<leader>ump", "<cmd>MarkdownPreview<cr>", "desc", "Start markdown preview"}, {"<leader>umt", "<cmd>MarkdownPreviewToggle<cr>", "desc", "Toggle markdown preview"}, {"<leader>ums", "<cmd>MarkdownPreviewStop<cr>", "desc", "Stop markdown preview"}}, ft = {"markdown"}, init = _1_, build = "cd app && yarn install"}}
