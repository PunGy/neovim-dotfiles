(import-macros {: map! : cmd!} :macros.vim)

(local {: is-in-arcadia : copy-arcadia-path} (require :utils.yndx))

(fn diag-jump [count severity]
  (fn []
    (vim.diagnostic.jump {: count
                          :severity (?. vim.diagnostic.severity severity)})))

(map! n :<C-x>q (cmd! :qa) {:desc "Quit NeoVim"})
(map! n :<C-x>Q (cmd! :qall!) {:desc "Quit NeoVim"})

(map! n :<C-Tab> (cmd! :tabclose) {:desc "Close tab"})
(map! n :<C-x>t (cmd! :tabclose) {:desc "Close tab"})
(map! n "]<Tab>" (cmd! :tabnext) {:desc "Next tab"})
(map! n "[<Tab>" (cmd! :tabprev) {:desc "Prev tab"})

;; Buffers
(map! n :<C-s> (cmd! :w) {:desc "Save the buffer"})

(map! n :<C-b>cn (fn []
                   (let [bufname (vim.fn.fnamemodify (vim.fn.expand "%:p") ":t")]
                     (vim.fn.setreg "+" bufname)))
      {:desc "Copy buffer name"})

(map! n :<C-b>cp (fn []
                   (let [cwd-path (vim.fn.fnamemodify (vim.fn.expand "%:p")
                                                      ":~:.")]
                     (vim.fn.setreg "+" cwd-path)))
      {:desc "Copy buffer path"})

(map! n :<C-b>o (cmd! "%bdelete|edit#|bdelete#") {:desc "Close other buffers"})

(if (is-in-arcadia)
    (map! n :<C-b>ca copy-arcadia-path {:desc "Copy path to file in arcadia"}))

;; Diagnostic
(map! n :<leader>dl #(vim.diagnostic.open_float {:focusable true})
      {:desc "Line Diagnostics"})

;; ]d/[d come from mini.bracketed; severity-filtered jumps remain explicit.
(map! n "]e" (diag-jump 1 :ERROR) {:desc "Next Error"})
(map! n "[e" (diag-jump -1 :ERROR) {:desc "Prev Error"})
(map! n "]w" (diag-jump 1 :WARN) {:desc "Next Warning"})
(map! n "[w" (diag-jump -1 :WARN) {:desc "Prev Warning"})

;; Misc
(map! nv :<C-y> "\"+y" {:desc "Copy to clipboard"})
(map! nv :<C-p> "\"+p" {:desc "Paste from clipboard"})
;; <C-a> stays vim's increment; select-all moves to <leader>a.
(map! n :<leader>a :gg<S-v>G {:desc "Select all"})

;; Double-tap <Esc> to clear search highlight; single <Esc> stays untouched.
(map! n :<Esc><Esc> (cmd! :noh))
