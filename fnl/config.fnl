(import-macros {: set!} :utils.vim)

(require :keymaps)

;; Number of spaces that a <Tab> in the file counts for
(set! tabstop 2)

;; Number of spaces that a <Tab> counts for while performing editing operations
(set! softtabstop 2)

(set! expandtab)

;; Convert tabs to spaces

;; Number of spaces to use for each step of (auto)indent
(set! shiftwidth 2)

;; Enable line numbers
(set! nu)

;; Enable relative line numbers
(set! relativenumber)

(set! smartindent)

;; Enable smart indentation
(set! numberwidth 3)

;; Set number column width for line numbers

(set! wrap false)

;; Disable line wrapping

(set! swapfile false)

;; Disable swapfile creation
(set! backup false)

;; Disable backup file creation

;; to save persistent undo information, ensuring that undo history is kept between sessions for files edited
(set! undodir (.. (os.getenv :HOME) :/.vim/undodir))
(set! undofile)

;; Enable persistent undo

;;(set! hlsearch false)  ;; Disable search highlighting
(set! incsearch)

;; Enable incremental search (search as you type)

(set! scrolloff 8)

;; Minimum number of screen lines to keep above and below the cursor
(set! signcolumn :yes)

;; Always show the sign column to avoid text shifting
(set! list)
