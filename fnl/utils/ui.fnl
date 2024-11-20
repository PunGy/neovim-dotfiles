(import-macros {: plug!} :utils.macros)
(local {: delete-buffer : current-buffer} (require :utils.vim))
(local {: find : filter} (require :utils.fn))

(fn unpin [buf-elem]
  (plug! :bufferline.groups :remove_element :pinned buf-elem))

(fn opened-buffers []
  (. (plug! :bufferline :get_elements) :elements))

(fn is-pinned [buf-elem]
  (plug! :bufferline.groups :_is_pinned buf-elem))

(fn unpin-all []
  (each [_ buf in (ipairs (filter (opened-buffers) is-pinned))]
    (unpin buf))
  ;; refresh
  (vim.schedule (fn [] (vim.cmd.redrawtabline))))

(fn close-buffer [buf? opts?]
  (local {: nvim_win_set_buf
          : nvim_win_get_buf
          : nvim_win_is_valid
          : nvim_win_call
          : nvim_create_buf} vim.api)
  (local {: confirm : win_findbuf : buflisted : bufname : bufnr} vim.fn)
  (local opts (or opts? {:silent false}))
  (local buf (or buf? (current-buffer)))
  (local buf-elem (find (opened-buffers) #(= (. $1 :id) buf)))

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

  (if (is-pinned buf-elem) ;; on try to remove pinned
      (when (not opts.silent)
        (print "Cannot remove pinned buffer! Unpin it first."))
      ;; on try to remove modified
      vim.bo.modified (let [choice (confirm (.. "Save changes to " (bufname))
                                            "&Yes\n&No\nCancel")]
                        (when (= choice 1)
                          (vim.cmd.write)
                          (arrange-for-windows)
                          (delete-buffer buf)))
      ;; on general remove
      (do
        (arrange-for-windows)
        (delete-buffer buf))))

(fn file-explorer []
  (plug! :neo-tree.command :execute {:dir (vim.loop.cwd) :reveal true}))

{: close-buffer : file-explorer : unpin-all}
