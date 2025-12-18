(import-macros {: cmd$ : term$} :macros.exec)
(import-macros {: map!} :macros.vim)

(local {: close-buffer : file-explorer} (require :utils.ui))

(local {: is-in-arcadia : copy-arcadia-path} (require :utils.yndx))
(local {: diagnostic-goto} (require :utils.navigation))

(map! n :<C-x>q (cmd$ :qa) "Quit NeoVim")
(map! n :<C-x>Q (cmd$ :qall!) "Quit NeoVim")

;; Tabs
(map! n :<C-Tab> (cmd$ :tabclose) "Close tab")
(map! n "]<Tab>" (cmd$ :tabnext) "Next tab")
(map! n "[<Tab>" (cmd$ :tabprev) "Prev tab")

;; Buffers
(map! n :<C-b>q close-buffer "Close buffer")
(map! n :<C-s> (cmd$ :w) "Save the buffer")

(map! n :<C-b>cn (fn []
                   (let [bufname (vim.fn.fnamemodify (vim.fn.expand "%:p") ":t")]
                     (vim.fn.setreg "+" bufname)))
      "Copy buffer name")

(map! n :<C-b>cp (fn []
                   (let [cwd-path (vim.fn.fnamemodify (vim.fn.expand "%:p")
                                                      ":~:.")]
                     (vim.fn.setreg "+" cwd-path)))
      "Copy buffer path")

(map! n :<C-b>o (cmd$ "%bdelete|edit#|bdelete#") "Close other buffers")

(if (is-in-arcadia)
    (map! n :<C-b>ca copy-arcadia-path "Copy path to file in arcadia"))

;; Diagnostic

(map! n :<leader>dl #(vim.diagnostic.open_float {:focusable true})
      "Line Diagnostics")

(map! n "]d" (diagnostic-goto true) "Next Diagnostic")
(map! n "[d" (diagnostic-goto false) "Prev Diagnostic")
(map! n "]e" (diagnostic-goto true :ERROR) "Next Error")
(map! n "[e" (diagnostic-goto false :ERROR) "Prev Error")
(map! n "]w" (diagnostic-goto true :WARN) "Next Warning")
(map! n "[w" (diagnostic-goto false :WARN) "Prev Warning")

;; Misc
(map! nv :<C-y> "\"+y" "Copy to clipboard")
(map! nv :<C-p> "\"+p" "Paste from clipboard")
; select all
(map! n :<C-a> :gg<S-v>G)

(map! n :<Esc> (cmd$ :noh) "Clear selection")
