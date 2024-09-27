--- --- Check if a file or directory exists in this path
function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path .. "/")
end

if isdir(os.getenv("HOME") .. "/arcadia/devtools") then
  return {
    dir = "~/arcadia/devtools/vim/plugin_bundles/signify",
    keys = {
      { "<leader>ga", desc = "Arcadia Signify" },
      { "<leader>gad", "<cmd>SignifyDiff<CR>", desc = "Show signify diff tab" },
      { "<leader>gan", "<cmd>SignifyEnable<CR>", desc = "Set signify oN" },
      { "<leader>gaf", "<cmd>SignifyDisable<CR>", desc = "Set signify ofF" },
    },
    dev = true,
  }
else
  return {}
end
