-- [nfnl] fnl/keymaps.fnl
local _local_1_ = require("utils.exec")
local cmd = _local_1_.cmd
local _local_2_ = require("utils.yndx")
local is_in_arcadia = _local_2_["is-in-arcadia"]
local copy_arcadia_path = _local_2_["copy-arcadia-path"]
local _local_3_ = require("utils.navigation")
local diagnostic_goto = _local_3_["diagnostic-goto"]
vim.keymap.set({"n"}, "<C-x>q", cmd("qa"), {desc = "Quit NeoVim"})
vim.keymap.set({"n"}, "<C-x>Q", cmd("qall!"), {desc = "Quit NeoVim"})
vim.keymap.set({"n"}, "<C-Tab>", cmd("tabclose"), {desc = "Close tab"})
vim.keymap.set({"n"}, "]<Tab>", cmd("tabnext"), {desc = "Next tab"})
vim.keymap.set({"n"}, "[<Tab>", cmd("tabprev"), {desc = "Prev tab"})
vim.keymap.set({"n"}, "<C-s>", cmd("w"), {desc = "Save the buffer"})
local function _4_()
  local bufname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")
  return vim.fn.setreg("+", bufname)
end
vim.keymap.set({"n"}, "<C-b>cn", _4_, {desc = "Copy buffer name"})
local function _5_()
  local cwd_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
  return vim.fn.setreg("+", cwd_path)
end
vim.keymap.set({"n"}, "<C-b>cp", _5_, {desc = "Copy buffer path"})
vim.keymap.set({"n"}, "<C-b>o", cmd("%bdelete|edit#|bdelete#"), {desc = "Close other buffers"})
if is_in_arcadia() then
  vim.keymap.set({"n"}, "<C-b>ca", copy_arcadia_path, {desc = "Copy path to file in arcadia"})
else
end
local function _7_()
  return vim.diagnostic.open_float({focusable = true})
end
vim.keymap.set({"n"}, "<leader>dl", _7_, {desc = "Line Diagnostics"})
vim.keymap.set({"n"}, "]d", diagnostic_goto(true), {desc = "Next Diagnostic"})
vim.keymap.set({"n"}, "[d", diagnostic_goto(false), {desc = "Prev Diagnostic"})
vim.keymap.set({"n"}, "]e", diagnostic_goto(true, "ERROR"), {desc = "Next Error"})
vim.keymap.set({"n"}, "[e", diagnostic_goto(false, "ERROR"), {desc = "Prev Error"})
vim.keymap.set({"n"}, "]w", diagnostic_goto(true, "WARN"), {desc = "Next Warning"})
vim.keymap.set({"n"}, "[w", diagnostic_goto(false, "WARN"), {desc = "Prev Warning"})
vim.keymap.set({"n", "v"}, "<C-y>", "\"+y", {desc = "Copy to clipboard"})
vim.keymap.set({"n", "v"}, "<C-p>", "\"+p", {desc = "Paste from clipboard"})
vim.keymap.set({"n"}, "<C-a>", "gg<S-v>G", {})
return vim.keymap.set({"n"}, "<Esc>", cmd("noh"), {desc = "Clear selection"})
