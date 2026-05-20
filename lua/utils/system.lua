-- [nfnl] fnl/utils/system.fnl
local function exists(path)
  return (vim.uv.fs_stat(path) ~= nil)
end
local function is_dir(path)
  local stat = vim.uv.fs_stat(path)
  return (stat and (stat.type == "directory"))
end
local function shell_cmd(cmd)
  local output = vim.fn.system(cmd)
  if (vim.v.shell_error == 0) then
    return string.sub(output, 1, -2)
  else
    return vim.notify(("Command failed: " .. output), vim.log.levels.ERROR)
  end
end
return {exists = exists, ["is-dir"] = is_dir, ["shell-cmd"] = shell_cmd}
