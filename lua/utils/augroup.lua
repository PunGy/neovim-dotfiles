-- [nfnl] fnl/utils/augroup.fnl
local function augroup(name)
  return vim.api.nvim_create_augroup(("lim/" .. name), {clear = true})
end
return {augroup = augroup}
