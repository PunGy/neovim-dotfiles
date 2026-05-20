(import-macros {: plug!} :macros.vim)

(local {: augroup} (require :utils.augroup))

(local au vim.api.nvim_create_autocmd)

;; Highlight on yank
(au :TextYankPost
    {:group (augroup :highlight-yank)
     :callback #(vim.hl.on_yank)})

;; LSP buffer-local maps and features
(fn on-lsp-attach [args]
  (let [bufnr args.buf
        client (vim.lsp.get_client_by_id args.data.client_id)]
    (fn map [lhs rhs desc]
      (vim.keymap.set :n lhs rhs {:buffer bufnr :silent true :desc desc}))

    ;; Hover with rounded border (overrides 0.11 default K mapping).
    (map :K
         #(vim.lsp.buf.hover {:border :rounded})
         "Hover docs")

    (map :<leader>cf
         #(plug! :conform :format {:bufnr bufnr :lsp_fallback true})
         "Format buffer")

    (map :<leader>cl vim.lsp.codelens.run "Run code lens")

    (map :<leader>th
         (fn []
           (let [filter {:bufnr bufnr}
                 enabled? (vim.lsp.inlay_hint.is_enabled filter)]
             (vim.lsp.inlay_hint.enable (not enabled?) filter)))
         "Toggle inlay hints")

    (map :<leader>tl
         (fn []
           (let [current (or (?. (vim.diagnostic.config) :virtual_lines) false)]
             (vim.diagnostic.config {:virtual_lines (not current)})))
         "Toggle virtual_lines diagnostics")

    ;; LSP-driven folding (outline-mode style) when server supports it.
    (when (and client (client:supports_method :textDocument/foldingRange))
      (set vim.wo.foldexpr "v:lua.vim.lsp.foldexpr()")
      (set vim.wo.foldmethod :expr))))

(au :LspAttach {:group (augroup :lsp-attach) :callback on-lsp-attach})

;; Auto-refresh codelens for buffers whose attached clients support it.
(au [:BufEnter :CursorHold :InsertLeave]
    {:group (augroup :lsp-codelens-refresh)
     :callback (fn [args]
                 (when (next (vim.lsp.get_clients
                               {:bufnr args.buf
                                :method :textDocument/codeLens}))
                   (vim.lsp.codelens.refresh {:bufnr args.buf})))})

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
