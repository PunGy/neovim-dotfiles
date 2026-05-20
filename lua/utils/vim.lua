-- [nfnl] fnl/utils/vim.fnl
local function current_buffer()
  return vim.api.nvim_get_current_buf()
end
local function delete_buffer(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    return pcall(vim.cmd, ("bdelete! " .. buf))
  else
    return nil
  end
end
return {["delete-buffer"] = delete_buffer, ["current-buffer"] = current_buffer}
