(import-macros {: map!} :macros.vim)

(local {: cmd} (require :utils.exec))
(local {: is-in-arcadia : copy-arcadia-path} (require :utils.yndx))
(local {: diagnostic-goto} (require :utils.navigation))

(map! n :<C-x>q (cmd :qa) {:desc "Quit NeoVim"})
(map! n :<C-x>Q (cmd :qall!) {:desc "Quit NeoVim"})

;; Tabs
(map! n :<C-Tab> (cmd :tabclose) {:desc "Close tab"})
(map! n "]<Tab>" (cmd :tabnext) {:desc "Next tab"})
(map! n "[<Tab>" (cmd :tabprev) {:desc "Prev tab"})

;; Buffers
(map! n :<C-s> (cmd :w) {:desc "Save the buffer"})

(map! n :<C-b>cn
      (fn []
        (let [bufname (vim.fn.fnamemodify (vim.fn.expand "%:p") ":t")]
          (vim.fn.setreg "+" bufname)))
      {:desc "Copy buffer name"})

(map! n :<C-b>cp
      (fn []
        (let [cwd-path (vim.fn.fnamemodify (vim.fn.expand "%:p") ":~:.")]
          (vim.fn.setreg "+" cwd-path)))
      {:desc "Copy buffer path"})

(map! n :<C-b>o (cmd "%bdelete|edit#|bdelete#") {:desc "Close other buffers"})

(if (is-in-arcadia)
    (map! n :<C-b>ca copy-arcadia-path {:desc "Copy path to file in arcadia"}))

;; Diagnostic
(map! n :<leader>dl #(vim.diagnostic.open_float {:focusable true})
      {:desc "Line Diagnostics"})

(map! n "]d" (diagnostic-goto true) {:desc "Next Diagnostic"})
(map! n "[d" (diagnostic-goto false) {:desc "Prev Diagnostic"})
(map! n "]e" (diagnostic-goto true :ERROR) {:desc "Next Error"})
(map! n "[e" (diagnostic-goto false :ERROR) {:desc "Prev Error"})
(map! n "]w" (diagnostic-goto true :WARN) {:desc "Next Warning"})
(map! n "[w" (diagnostic-goto false :WARN) {:desc "Prev Warning"})

;; Misc
(map! nv :<C-y> "\"+y" {:desc "Copy to clipboard"})
(map! nv :<C-p> "\"+p" {:desc "Paste from clipboard"})
; select all
(map! n :<C-a> :gg<S-v>G)

(map! n :<Esc> (cmd :noh) {:desc "Clear selection"})
