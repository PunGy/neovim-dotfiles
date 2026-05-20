-- [nfnl] fnl/plugins/misc.fnl
local function _1_()
  return require("persistence").load({last = true})
end
local function _2_()
  return require("persistence").select()
end
local function _3_()
  return require("mini.bufremove").delete(0, false)
end
return {{"folke/persistence.nvim", keys = {{"<C-x>l", _1_, desc = "Restore last session"}, {"<C-x>s", _2_, desc = "Select session"}}, opts = {dir = (vim.fn.stdpath("state") .. "/sessions/"), need = 0}, lazy = false}, {"echasnovski/mini.bufremove", keys = {{"<C-x>b", _3_, desc = "Close buffer"}}}, {"echasnovski/mini.bracketed", event = "BufReadPost", opts = {buffer = {suffix = "b"}, comment = {suffix = "c"}, conflict = {suffix = "x"}, diagnostic = {suffix = "d"}, file = {suffix = ""}, indent = {suffix = ""}, jump = {suffix = "j"}, location = {suffix = "l"}, oldfile = {suffix = "o"}, quickfix = {suffix = "q"}, treesitter = {suffix = "n"}, undo = {suffix = ""}, window = {suffix = "w"}, yank = {suffix = "y"}}}}
