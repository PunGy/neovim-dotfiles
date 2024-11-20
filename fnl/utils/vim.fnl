;; Creates a handler just like a cmd$, but not a macro
(fn cmd$0 [cmd]
  (.. :<cwd> cmd :<cr>))

(fn current-buffer []
  (vim.api.nvim_get_current_buf))

(fn delete-buffer [buf]
  (when (vim.api.nvim_buf_is_valid buf)
    (pcall vim.cmd (.. "bdelete! " buf))))

(fn insert-timestamp []
  (let [timestamp (os.date "(%H:%M): ")]
    (vim.api.nvim_put [timestamp] :c true true)))

{: cmd$0 : delete-buffer : current-buffer : insert-timestamp}
