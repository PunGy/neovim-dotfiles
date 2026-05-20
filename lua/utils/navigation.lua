-- [nfnl] fnl/utils/navigation.fnl
local function diagnostic_goto(next, _3fseverity)
  local count
  if next then
    count = 1
  else
    count = -1
  end
  local severity
  if _3fseverity then
    severity = vim.diagnostic.severity[_3fseverity]
  else
    severity = nil
  end
  local function _3_()
    return vim.diagnostic.jump({count = count, severity = severity})
  end
  return _3_
end
return {["diagnostic-goto"] = diagnostic_goto}
