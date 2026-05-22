(import-macros {: plug!} :macros.vim)

(local {: augroup} (require :utils.augroup))

(local au vim.api.nvim_create_autocmd)

;; Highlight on yank
(au :TextYankPost
    {:group (augroup :highlight-yank)
     :callback #(vim.hl.on_yank)})

;; LSP buffer-local maps and features.
;;
;; `bmap!` is defined here as a local macro that captures `bufnr` from the
;; surrounding `let` by free reference — each call expands at compile time to
;; a single `vim.keymap.set` form. No runtime closure, no helper function.
(fn on-lsp-attach [args]
  (let [bufnr args.buf
        client (vim.lsp.get_client_by_id args.data.client_id)]
    (macro bmap! [lhs rhs desc]
      `(vim.keymap.set :n ,lhs ,rhs
                       {:buffer bufnr :silent true :desc ,desc}))

    (bmap! :K
           #(vim.lsp.buf.hover {:border :rounded})
           "Hover docs")

    (bmap! :<leader>cf
           #(plug! :conform :format {:bufnr bufnr :lsp_fallback true})
           "Format buffer")

    (bmap! :<leader>cl vim.lsp.codelens.run "Run code lens")

    (bmap! :<leader>th
           (fn []
             (let [filter {:bufnr bufnr}
                   enabled? (vim.lsp.inlay_hint.is_enabled filter)]
               (vim.lsp.inlay_hint.enable (not enabled?) filter)))
           "Toggle inlay hints")

    (bmap! :<leader>tl
           (fn []
             (let [current (or (?. (vim.diagnostic.config) :virtual_lines) false)]
               (vim.diagnostic.config {:virtual_lines (not current)})))
           "Toggle virtual_lines diagnostics")

    ;; LSP folding when the server advertises foldingRange. foldlevelstart=99
    ;; (in config.fnl) keeps folds open on load — use z*/zc/zM to operate.
    (when (and client (client:supports_method :textDocument/foldingRange))
      (set vim.wo.foldmethod :expr)
      (set vim.wo.foldexpr "v:lua.vim.lsp.foldexpr()"))

    (when (and client (client:supports_method :textDocument/codeLens))
      (vim.lsp.codelens.enable true {:bufnr bufnr}))

    (when (and client (= client.name :ts_ls))
      (set client.server_capabilities.documentFormattingProvider false))))

(au :LspAttach {:group (augroup :lsp-attach) :callback on-lsp-attach})

;; Restore cursor position on file open
(au :BufReadPost
    {:group (augroup :restore-cursor)
     :callback (fn []
                 (let [ft vim.bo.filetype
                       line (vim.fn.line "'\"")
                       last (vim.fn.line "$")]
                   (when (and (> line 1) (<= line last)
                              (not (vim.tbl_contains [:gitcommit :gitrebase] ft)))
                     (vim.cmd "normal! g`\""))))})

;; Lisp-family tweaks: treat -, ?, ! as word chars so * and gd match whole symbols
(au :FileType
    {:group (augroup :lisp-ft)
     :pattern [:fennel :lisp :clojure :scheme :commonlisp]
     :callback (fn []
                 (: vim.opt_local.iskeyword :append [:- :? :!]))})
