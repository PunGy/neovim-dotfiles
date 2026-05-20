-- [nfnl] fnl/plugins/ui/theme.fnl
local light = "modus_operandi"
local dark = "modus_vivendi"
local function apply(scheme)
  if (scheme == light) then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
  return vim.cmd(("colorscheme " .. scheme))
end
local function _2_()
  require("modus-themes").setup({line_nr_column_background = false})
  local function _3_()
    return apply(light)
  end
  vim.api.nvim_create_user_command("Light", _3_, {desc = "Switch to modus light"})
  local function _4_()
    return apply(dark)
  end
  vim.api.nvim_create_user_command("Dark", _4_, {desc = "Switch to modus dark"})
  local function _5_()
    if (vim.env.THEME == "light") then
      return light
    else
      return dark
    end
  end
  return apply(_5_())
end
return {{"miikanissi/modus-themes.nvim", priority = 1000, config = _2_, lazy = false}}
