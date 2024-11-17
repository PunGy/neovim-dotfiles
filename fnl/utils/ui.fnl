(import-macros {: plug!} :utils.macros)
(local {: delete-buffer : current-buffer} (require :utils.vim))
(local {: find} (require :utils.fn))

(fn close-buffer [buf?]
  (local {: nvim_win_set_buf
          : nvim_win_get_buf
          : nvim_win_is_valid
          : nvim_win_call
          : nvim_create_buf} vim.api)
  (local {: confirm : win_findbuf : buflisted : bufname : bufnr} vim.fn)
  (local buf (or buf? (current-buffer)))
  (local buf-elem (find (. (plug! :bufferline :get_elements) :elements)
                        #(= (. $1 :id) buf)))

  (fn arrange-for-windows []
    (each [_ win (ipairs (win_findbuf buf))]
      (nvim_win_call win
                     (fn []
                       (when (and (nvim_win_is_valid win)
                                  (= (nvim_win_get_buf win) buf))
                         (let [alt (bufnr "#")]
                           (if (and (not= alt buf) (= (buflisted alt) 1))
                               (nvim_win_set_buf win alt)
                               (and (pcall vim.cmd :bprevious) ;; has previous
                                    (not= buf (nvim_win_get_buf win)) nil
                                    (let [new-buf (nvim_create_buf true false)]
                                      (nvim_win_set_buf win new-buf))))))))))

  (if (plug! :bufferline.groups :_is_pinned buf-elem)
      (print "Cannot remove pinned buffer! Unpin it first.")
      vim.bo.modified
      (let [choice (confirm (.. "Save changes to " (bufname))
                            "&Yes\n&No\nCancel")]
        (when (= choice 1)
          (vim.cmd.write)
          (arrange-for-windows)
          (delete-buffer buf)))
      (do
        (arrange-for-windows)
        (delete-buffer buf))))

(fn file-explorer []
  (plug! :neo-tree.command :execute {:dir (vim.loop.cwd) :reveal true}))

{: close-buffer : file-explorer}
