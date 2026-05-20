-- [nfnl] fnl/plugins/ui/theme.fnl
local function _1_(_, opts)
  require("modus-themes").setup({line_nr_column_background = false})
  if (vim.env.THEME == "light") then
    return vim.cmd("colorscheme modus_operandi")
  else
    return vim.cmd("colorscheme modus_vivendi")
  end
end
return {{"miikanissi/modus-themes.nvim", priority = 1000, config = _1_}}
