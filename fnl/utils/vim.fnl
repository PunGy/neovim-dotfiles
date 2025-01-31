;; Creates a handler just like a cmd$, but not a macro
(fn cmd$0 [cmd]
  (.. :<cwd> cmd :<cr>))

(fn current-buffer []
  (vim.api.nvim_get_current_buf))

(fn delete-buffer [buf]
  (when (vim.api.nvim_buf_is_valid buf)
    (pcall vim.cmd (.. "bdelete! " buf))))

;(fn all-buffers []
;  (vim.fn.getbufinfo)
;  (each [_ buffer (ipairs (vim.fn.getbufinfo))]
;    (let [{: bufnr} buffer]
;      (if (and (vim.fn.buflisted bufnr) (vim.api.nvim_buf_is_loaded bufnr)
;               (vim.api.nvim_buf_is_valid bufnr))
;          (print bufnr)))))

{: cmd$0 : delete-buffer : current-buffer}
