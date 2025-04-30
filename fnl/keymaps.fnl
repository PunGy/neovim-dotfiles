(import-macros {: map! : set!} :hibiscus.vim)
(import-macros {: cmd$ : plug$ : plug! : plug->} :utils.macros)
(local {: close-buffer : file-explorer } (require :utils.ui))
(local {: diagnostic-goto : cmd$0} (require :utils.code))
(local {: is-in-arcadia} (require :utils.yndx))

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

;(map! [n] :<C-i>p (cmd$ :PasteImage) "Paste image from system clipboard")

;; Buffer management
(map! [n] :<C-b>q close-buffer "Close buffer gracefully")

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

(map! [ni] :<C-b>o (cmd$ "%bdelete|edit#|bdelete#") "Close other buffers")

;; Tab management

(map! [n] :<C-Tab> (cmd$ :tabnext) "Next tab")

;; clear search
(map! [ni] :<esc> :<cmd>noh<cr><esc>)

;; diagnostics navigatoin
(map! [n] :<leader>dl #(vim.diagnostic.open_float {:focusable true})
      "Line Diagnostics")
(map! [n] :<leader>df (cmd$ "FzfLua diagnostics_document") "File Diagnostics")
(map! [n] :<leader>dw (cmd$ "FzfLua diagnostics_workspace") "Workspace Diagnostics")
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
(map! [n] :<C-x>sl (plug$ :persistence :load {:last true})
      "Restore last session")

(map! [n] :<C-x>ss (plug$ :persistence :select) "Select session")
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

(map! [n] :<leader>um (cmd$ ":RenderMarkdown toggle")
      "Toggle in-editor markdown preview")

(map! [n] :<leader>uM (cmd$ ":MarkdownPreviewToggle")
      "Toggle external markdown preview")

;; LSP Keymaps
(map! [n] :gd (cmd$ "FzfLua lsp_definitions") "Go to definition")
(map! [n] :gD (cmd$ "FzfLua lsp_declarations") "Go to declaration")
(map! [n] :gr (cmd$ "FzfLua lsp_references") :References)
(map! [n] :K vim.lsp.buf.hover :Hover)
(map! [ni] :<C-k> vim.lsp.buf.signature_help "Signature help")
(map! [n] :<leader>ca vim.lsp.buf.code_action "Code actions")
(map! [n] :<leader>cr vim.lsp.buf.rename :Rename)

(map! [xn] :<leader>cp #(plug-> :refactoring [:debug :print_var])
      "Show selected")
(map! [xn] :<leader>cc #(plug-> :refactoring [:debug :cleanup] {})
      "Clear debug entries")
(map! [x] :<leader>cf (cmd$ "Refactor extract ") "Extract function")
(map! [x] :<leader>cF (cmd$ "Refactor extract_to_file ")
      "Extract function to file")
(map! [x] :<leader>cv (cmd$ "Refactor extract_var  ") "Extract variable")
(map! [xn] :<leader>cR #(plug-> :refactoring [:select_refactor])
      :Refactoring...)

;;;;;;;;;;;;;;;
;; Exploring ;;
;;;;;;;;;;;;;;;

(map! [n] :<leader>fs (cmd$ "FzfLua resume") "Resume last search")

;; File explorer ;;

(map! [n] :<leader>e file-explorer "File Explorer")
(map! [n] :<leader>ff (cmd$ "FzfLua files") "Find files")
(map! [n] :<leader>fb (cmd$ "FzfLua buffers") "Find buffers")

(fn fzf-arcadia []
  (plug! :fzf-lua :files
         {:cmd "arc status -s | awk '{print substr($0, index($0,$2))}'"}))

(if (is-in-arcadia)
    (map! [n] :<leader>fv fzf-arcadia "Find changed files")
    (map! [n] :<leader>fv (cmd$ "FzfLua git_status") "Find changed files"))

(map! [n] :<leader>pa (fn []
                        (let [harpoon (require :harpoon)]
                          (: (harpoon:list) :add)))
      "Pin a line")

(map! [n] :<leader>pu (fn []
                        (let [harpoon (require :harpoon)]
                          (: (harpoon:list) :clear)))
      "Unpin all")

;; Searching ;;

(map! [nv] :<leader>sr
      (fn []
        (let [ext (and (= vim.bo.buftype "") (vim.fn.expand "%:e"))]
          (plug! :grug-far :open
                 {:transient true
                  :prefills {:filesFilter (or (and ext (not= ext "")
                                                   (.. "*." ext))
                                              nil)}})))
      "Search and Replace")

(map! [n] :<leader>ss (cmd$ "FzfLua lsp_document_symbols")
      "Search for a symbol here")

(map! [n] :<leader>sb (cmd$ "FzfLua lines") "Search in buffes")

(map! [n] :<leader>sw (cmd$ "FzfLua lsp_workspace_symbols")
      "Search for a symbol in project")

(map! [n] :<leader>sg (cmd$ "FzfLua live_grep_glob") "Grep project")
(map! [n] :<leader>/ (cmd$ "FzfLua blines") "Search here")

;; Debbuging


(map! [n] :<leader>ih (cmd$ :DapToggleBreakpoint) "Add breakpoint at line")
(map! [n] :<leader>ir (cmd$ :DapContinue) "Start or Continue debbuging")
(map! [n] :<leader>ii (cmd$ :DapStepInto) "Step Into")
(map! [n] :<leader>io (cmd$ :DapStepOver) "Step Over")
(map! [n] :<leader>it (cmd$ :DapStepOver) "Terminate Debbuging")
