{1 :stevearc/conform.nvim
 :keys [[:<C-f>
         (fn []
           (let [buf (vim.api.nvim_get_current_buf)
                 conform (require :conform)]
             (if (= (next (conform.list_formatters)) nil)
                 (vim.lsp.buf.format)
                 (conform.format {:bufnr buf}))))]]
 :opts {:formatters {:cl-indentify {:command :cl-indentify :args [:-r]}}
        :formatters_by_ft {:fennel [:fnlfmt]
                           :lisp [:cl-indentify]
                           :lua [:stylua]
                           :c [:clang_format]
                           :cpp [:clang_format]
                           :markdown [:markdownlint-cli2]}}}
