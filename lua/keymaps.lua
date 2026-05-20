-- [nfnl] fnl/keymaps.fnl
local _local_1_ = require("utils.yndx")
local is_in_arcadia = _local_1_["is-in-arcadia"]
local copy_arcadia_path = _local_1_["copy-arcadia-path"]
local function diag_jump(count, severity)
  local function _2_()
    local _4_
    do
      local t_3_ = vim.diagnostic.severity
      if (nil ~= t_3_) then
        t_3_ = t_3_[severity]
      else
      end
      _4_ = t_3_
    end
    return vim.diagnostic.jump({count = count, severity = _4_})
  end
  return _2_
end
vim.keymap.set({"n"}, "<C-x>q", "<cmd>qa<cr>", {desc = "Quit NeoVim"})
vim.keymap.set({"n"}, "<C-x>Q", "<cmd>qall!<cr>", {desc = "Quit NeoVim"})
vim.keymap.set({"n"}, "<C-Tab>", "<cmd>tabclose<cr>", {desc = "Close tab"})
vim.keymap.set({"n"}, "<C-x>t", "<cmd>tabclose<cr>", {desc = "Close tab"})
vim.keymap.set({"n"}, "]<Tab>", "<cmd>tabnext<cr>", {desc = "Next tab"})
vim.keymap.set({"n"}, "[<Tab>", "<cmd>tabprev<cr>", {desc = "Prev tab"})
vim.keymap.set({"n"}, "<C-s>", "<cmd>w<cr>", {desc = "Save the buffer"})
local function _6_()
  local bufname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")
  return vim.fn.setreg("+", bufname)
end
vim.keymap.set({"n"}, "<C-b>cn", _6_, {desc = "Copy buffer name"})
local function _7_()
  local cwd_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
  return vim.fn.setreg("+", cwd_path)
end
vim.keymap.set({"n"}, "<C-b>cp", _7_, {desc = "Copy buffer path"})
vim.keymap.set({"n"}, "<C-b>o", "<cmd>%bdelete|edit#|bdelete#<cr>", {desc = "Close other buffers"})
if is_in_arcadia() then
  vim.keymap.set({"n"}, "<C-b>ca", copy_arcadia_path, {desc = "Copy path to file in arcadia"})
else
end
local function _9_()
  return vim.diagnostic.open_float({focusable = true})
end
vim.keymap.set({"n"}, "<leader>dl", _9_, {desc = "Line Diagnostics"})
vim.keymap.set({"n"}, "]e", diag_jump(1, "ERROR"), {desc = "Next Error"})
vim.keymap.set({"n"}, "[e", diag_jump(-1, "ERROR"), {desc = "Prev Error"})
vim.keymap.set({"n"}, "]w", diag_jump(1, "WARN"), {desc = "Next Warning"})
vim.keymap.set({"n"}, "[w", diag_jump(-1, "WARN"), {desc = "Prev Warning"})
vim.keymap.set({"n", "v"}, "<C-y>", "\"+y", {desc = "Copy to clipboard"})
vim.keymap.set({"n", "v"}, "<C-p>", "\"+p", {desc = "Paste from clipboard"})
vim.keymap.set({"n"}, "<leader>a", "gg<S-v>G", {desc = "Select all"})
return vim.keymap.set({"n"}, "<Esc><Esc>", "<cmd>noh<cr>", {})
