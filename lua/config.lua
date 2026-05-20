-- [nfnl] fnl/config.fnl
require("keymaps")
vim["opt"]["tabstop"] = 2
vim["opt"]["fixeol"] = true
vim["opt"]["softtabstop"] = 2
vim["opt"]["expandtab"] = true
vim["opt"]["shiftwidth"] = 2
vim["opt"]["nu"] = true
vim["opt"]["relativenumber"] = true
vim["opt"]["smartindent"] = true
vim["opt"]["numberwidth"] = 3
vim["opt"]["wrap"] = false
vim["opt"]["swapfile"] = false
vim["opt"]["backup"] = false
vim["opt"]["undodir"] = (os.getenv("HOME") .. "/.vim/undodir")
vim["opt"]["undofile"] = true
vim["opt"]["incsearch"] = true
vim["opt"]["scrolloff"] = 8
vim["opt"]["signcolumn"] = "yes"
vim["opt"]["list"] = true
local space = "\194\183"
return vim.opt.listchars:append({nbsp = space, tab = "\194\183 ", trail = space})
