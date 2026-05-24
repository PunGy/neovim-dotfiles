-- [nfnl] fnl/plugins/ui/theme.fnl
local light = "lunaperche"
local dark = "lunaperche"
local function apply(scheme, background)
  vim.o.background = background
  return vim.cmd(("colorscheme " .. scheme))
end
local function _1_()
  require("modus-themes").setup({line_nr_column_background = false})
  local function _2_()
    return apply(light, "light")
  end
  vim.api.nvim_create_user_command("Light", _2_, {desc = "Switch to modus light"})
  local function _3_()
    return apply(dark, "dark")
  end
  vim.api.nvim_create_user_command("Dark", _3_, {desc = "Switch to modus dark"})
  local theme = vim.env.THEME
  local _4_
  if ("light" == theme) then
    _4_ = light
  else
    _4_ = dark
  end
  return apply(_4_, theme)
end
return {{"miikanissi/modus-themes.nvim", priority = 1000, config = _1_, lazy = false}}
