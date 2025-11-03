(import-macros {: cmd$} :macros.exec)
(import-macros {: map!} :macros.vim)

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

