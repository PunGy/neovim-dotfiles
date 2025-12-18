(fn current-buffer []
  (vim.api.nvim_get_current_buf))

(fn delete-buffer [buf]
  (when (vim.api.nvim_buf_is_valid buf)
    (pcall vim.cmd (.. "bdelete! " buf))))

{: delete-buffer : current-buffer}
