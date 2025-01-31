(import-macros {: plug!} :utils.macros)
(local {: delete-buffer : current-buffer} (require :utils.vim))
(local {: find : filter} (require :utils.fn))

(fn close-buffer [buf? opts?]
  (local {: nvim_win_set_buf
          : nvim_win_get_buf
          : nvim_win_is_valid
          : nvim_win_call
          : nvim_create_buf} vim.api)
  (local {: confirm : win_findbuf : buflisted : bufname : bufnr} vim.fn)
  (local opts (or opts? {:silent false}))
  (local buf (or buf? (current-buffer)))

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

  (if vim.bo.modified ;; on try to remove modified
      (let [choice (confirm (.. "Save changes to " (bufname))
                            "&Yes\n&No\nCancel")]
        (when (= choice 1)
          (vim.cmd.write)
          (arrange-for-windows)
          (delete-buffer buf))))
  ;; on general remove
  (do
    (arrange-for-windows)
    (delete-buffer buf)))

;(fn close-all-buffers []
;  (let [cur (vim.api.nvim_get_current_buf)]
;    (each [_ buf (ipairs (vim.api.nvim_list_bufs))]
;      (when (not= buf cur)
;        (close-buffer buf)))))

(fn file-explorer []
  (plug! :neo-tree.command :execute {:dir (vim.loop.cwd) :reveal true}))

(fn extended-hover []
  (local util (require :vim.lsp.util))
  (vim.lsp.buf_request 0 :textDocument/hover (util.make_position_params)
                       (fn [_ result ctx config]
                         (set-forcibly! config (or config {}))
                         (set config.focus_id ctx.method)
                         (when (not (and result result.contents))
                           (lua "return "))
                         (var markdown-lines
                              (util.convert_input_to_markdown_lines result.contents))
                         (set markdown-lines
                              (util.trim_empty_lines markdown-lines))
                         (when (vim.tbl_isempty markdown-lines) (lua "return "))
                         (vim.api.nvim_command " new ")
                         (vim.api.nvim_buf_set_lines 0 0 1 false markdown-lines)
                         (vim.api.nvim_command " setlocal ft=markdown ")
                         (vim.api.nvim_command " nnoremap <buffer>q <C-W>c ")
                         (vim.api.nvim_command " setlocal buftype+=nofile ")
                         (vim.api.nvim_command " setlocal nobl ")
                         (vim.api.nvim_command " setlocal conceallevel=2 ")
                         (vim.api.nvim_command " setlocal concealcursor+=cn "))))

{: close-buffer : file-explorer : extended-hover}
