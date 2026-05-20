-- [nfnl] fnl/utils/yndx.fnl
local function is_in_arcadia()
  return vim.fn.getcwd():match("arcadia")
end
local function copy_arcadia_path()
  local _let_1_ = vim.api.nvim_win_get_cursor(0)
  local linenum = _let_1_[1]
  local arc_path = string.sub(vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:"), 2)
  return vim.fn.setreg("+", ("https://a.yandex-team.ru" .. arc_path .. "#L" .. linenum))
end
return {["is-in-arcadia"] = is_in_arcadia, ["copy-arcadia-path"] = copy_arcadia_path}
