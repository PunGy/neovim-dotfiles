(import-macros {: map! : set!} :hibiscus.vim)
(import-macros {: cmd$ : plug$ : plug!} :utils.macros)
(local {: close-buffer : file-explorer : unpin-all} (require :utils.ui))
(local {: diagnostic-goto : cmd$0} (require :utils.code))

;;;;;;;;;;;;
;; SYSTEM
;;;;;;;;;;;;

;; Select all
(map! [n] :<C-a> :gg<S-v>G)
;; Select line without new line symbol
(map! [n :remap] :<A-v> :_v$h)
;; Save on shortcut
(map! [nixs] :<C-s> :<cmd>w<CR><esc>)

;; Copy-paste from system clipboard
(map! [nv] :<C-y> "\"+y" "System clipboard yank")
(map! [nv] :<C-p> "\"+p" "System clipboard paste")
(map! [nv] :<C-S-p> "\"+P" "System clipboard paste")

(map! [ni] :<C-i>p (cmd$ :PasteImage) "Paste image from system clipboard")

;; Buffer management
(map! [n] :<C-b>q close-buffer "Close buffer gracefully")

;;(map! [n] :<S-h> (cmd$ :bprev))
;;(map! [n] :<S-l> (cmd$ :bnext))
(map! [ni] :<C-b>p (cmd$ :BufferLineTogglePin) "Pin buffer")
(map! [ni] :<C-b>cn (fn []
                      (let [bufname (vim.fn.fnamemodify (vim.fn.expand "%:p")
                                                        ":t")]
                        (vim.fn.setreg "+" bufname)))
      "Copy buffer name")

(map! [ni] :<C-b>cp (fn []
                      (let [cwd-path (vim.fn.fnamemodify (vim.fn.expand "%:p")
                                                         ":~:.")]
                        (vim.fn.setreg "+" cwd-path)))
      "Copy buffer path")

(import-macros {: map! : set!} :hibiscus.vim)
(import-macros {: cmd$ : plug$ : plug!} :utils.macros)
(for [i 1 4]
  (map! [ni] (.. :<C-b> i) (plug$ :bufferline :go_to i true) "Go to buffer"))

(map! [ni] :<C-b>$ (cmd$ "BufferLineGoToBuffer -1") "Go to last tab")
(map! [ni] :<C-b>o (cmd$ "BufferLineCloseOthers")
      "Close other buffers")
(map! [n] :<C-b>u unpin-all "Unpin all buffers")

;; clear search
(map! [ni] :<esc> :<cmd>noh<cr><esc>)

;; diagnostics navigatoin
(map! [n] :<leader>cd vim.diagnostic.open_float "Line Diagnostics")
(map! [n] "]d" (diagnostic-goto true) "Next Diagnostic")
(map! [n] "[d" (diagnostic-goto false) "Prev Diagnostic")
(map! [n] "]e" (diagnostic-goto true :ERROR) "Next Error")
(map! [n] "[e" (diagnostic-goto false :ERROR) "Prev Error")
(map! [n] "]w" (diagnostic-goto true :WARN) "Next Warning")
(map! [n] "[w" (diagnostic-goto false :WARN) "Prev Warning")

;;;;;;;;;
;; UI
;;;;;;;;;

;; Session management
(map! [n] :<C-x>l (plug$ :persistence :load {:last true})
      "Restore last session")

(map! [n] :<leader>qs (plug$ :persistence :select) "Select session")
(map! [n] :<C-x>q (cmd$ :qa) "Quit NeoVim")

;; Menus
(map! [n] :<leader>mp (cmd$ :Lazy) "Package manager")
(map! [n] :<leader>mL (cmd$ :LspInfo) :LSP)
(map! [n] :<leader>mm (cmd$ :Mason) :Mason)
(map! [n] :<leader>ml (cmd$ :messages) "Messages log")
(map! [n] :<leader>md (cmd$ :Dashboard) "Show startup dashboard")

(map! [n] :<leader>h vim.cmd.UndotreeToggle "Show undo tree")

;; Window management
(map! [n] :<leader>| (cmd$ :vsplit) "Vertical split")
(map! [n] :<leader>- (cmd$ :split) "Horizontal split")
(map! [n :remap] :<C-j> :<C-w>j)
(map! [n :remap] :<C-k> :<C-w>k)
(map! [n :remap] :<C-h> :<C-w>h)
(map! [n :remap] :<C-l> :<C-w>l)

;; Togglers
(map! [n] :<leader>uc (plug$ :nvim-highlight-colors :toggle)
      "Toggle text-colors highlight")

(map! [n] :<leader>ul (fn [] (set! relativenumber!)) "Toggle relative lines")

(map! [n] :<leader>um (cmd$ ":RenderMarkdown toggle") "Toggle in-editor markdown preview")
(map! [n] :<leader>uM (cmd$ ":MarkdownPreviewToggle") "Toggle external markdown preview")

;; LSP Keymaps
(map! [n] :gd (cmd$ "FzfLua lsp_definitions") "Go to definition")
(map! [n] :gD (cmd$ "FzfLua lsp_declarations") "Go to declaration")
(map! [n] :gr (cmd$ "FzfLua lsp_references") :References)
(map! [n] :K vim.lsp.buf.hover :Hover)
(map! [n] :gK vim.lsp.buf.signature_help "Signature help")
(map! [i] :<C-k> vim.lsp.buf.signature_help "Signature help")
(map! [n] :<leader>ca vim.lsp.buf.code_action "Code actions")
(map! [n] :<leader>cr vim.lsp.buf.rename :Rename)

;; Explorers
(map! [nv] :<leader>sr
      (fn []
        (let [ext (and (= vim.bo.buftype "") (vim.fn.expand "%:e"))]
          (plug! :grug-far :open
                 {:transient true
                  :prefills {:filesFilter (or (and ext (not= ext "")
                                                   (.. "*." ext))
                                              nil)}})))
      "Search and Replace")

(map! [n] :<leader>e file-explorer "File Explorer")

(map! [n] :<leader>ff (cmd$ "FzfLua files") "Find files")
(map! [n] :<leader>fb (cmd$ "FzfLua buffers") "Find buffers")
(map! [n] :<leader>ss (cmd$ "FzfLua lsp_document_symbols")
      "Search for a symbol here")
(map! [n] :<leader>sb (cmd$ "FzfLua lines") "Search in buffes")

(map! [n] :<leader>sw (cmd$ "FzfLua lsp_workspace_symbols")
      "Search for a symbol in project")

(map! [n] :<leader>sg (cmd$ "FzfLua live_grep_glob") "Grep project")
(map! [n] :<leader>/ (cmd$ "FzfLua blines") "Search here")


