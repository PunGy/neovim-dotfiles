-- [nfnl] fnl/plugins/misc.fnl
local function _1_()
  return require("persistence").load({last = true})
end
local function _2_()
  return require("persistence").select()
end
local function _3_()
  return {dir = (vim.fn.stdpath("state") .. "/sessions/"), need = 0}
end
local function _4_()
  return require("mini.bufremove").delete(0, false)
end
return {{"folke/persistence.nvim", keys = {{"<C-x>l", _1_, "desc", "Restore last session"}, {"<C-x>s", _2_}}, opts = _3_, lazy = false}, {"echasnovski/mini.bufremove", keys = {{"<C-b>q", _4_, "desc", "Close buffer"}}}}
