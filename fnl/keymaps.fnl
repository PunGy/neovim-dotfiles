(import-macros {: cmd$ : term$} :macros.exec)
(import-macros {: map!} :macros.vim)

(local {: is-in-arcadia : copy-arcadia-path} (require :utils.yndx))

(map! nv :<C-y> "\"+y" "Copy to clipboard")
(map! nv :<C-p> "\"+p" "Paste from clipboard")
(map! n :<C-s> (cmd$ :w) "Save the buffer")
(map! n :<C-x>q (cmd$ :qa) "Quit NeoVim")
(map! n :<C-x>Q (cmd$ :qall!) "Quit NeoVim")
(map! n :<Esc> (cmd$ :noh) "Clear selection")
(map! n :<C-b>q (cmd$ :bdelete) "Close buffer")

(map! n :<C-Tab> (cmd$ :tabclose) "Close tab")
(map! n "]<Tab>" (cmd$ :tabnext) "Next tab")
(map! n "[<Tab>" (cmd$ :tabprev) "Prev tab")

; select all
(map! n :<C-a> :gg<S-v>G)

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
