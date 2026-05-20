-- [nfnl] fnl/plugins/ui/misc.fnl
local function _1_()
  return require("nvim-highlight-colors").toggle()
end
return {{"nvim-tree/nvim-web-devicons"}, {"echasnovski/mini.icons"}, {"folke/which-key.nvim"}, {"brenoprata10/nvim-highlight-colors", keys = {{"<leader>uc", _1_}}}, {"saghen/blink.cmp", dependencies = {"rafamadriz/friendly-snippets"}, version = "1.*", opts = {keymap = {preset = "none", ["<C-e>"] = {"hide", "fallback"}, ["<C-n>"] = {"select_next"}, ["<C-p>"] = {"select_prev"}, ["<M-k>"] = {"show_documentation", "hide_documentation"}, ["<C-Enter>"] = {"select_and_accept"}}, cmdline = {enabled = true, keymap = {preset = "inherit", ["<M-Enter>"] = {"select_accept_and_enter"}}, completion = {menu = {auto_show = true, draw = {columns = {{"label", "label_description", gap = 1}, {"kind_icon", "kind"}}}}}}}}, {"mbbill/undotree", keys = {{"<leader>h", vim.cmd.UndotreeToggle, "desc", "Show buffer history"}}}}
