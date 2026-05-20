-- [nfnl] fnl/utils/exec.fnl
local function cmd(c)
  return ("<cmd>" .. c .. "<cr>")
end
local function term_cmd(c)
  return ("<cmd>terminal " .. c .. "<cr>")
end
return {cmd = cmd, ["term-cmd"] = term_cmd}
