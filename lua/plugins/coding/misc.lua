-- [nfnl] fnl/plugins/coding/misc.fnl
local function _1_()
  return require("nvim-surround").setup()
end
return {{"AndrewRadev/switch.vim"}, {"kylechui/nvim-surround", event = "VeryLazy", config = _1_}}
