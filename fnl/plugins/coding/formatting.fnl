(import-macros {: plug!} :macros.vim)

[{1 :stevearc/conform.nvim
  :keys [{1 :<C-f>
          2 #(plug! :conform :format {:lsp_fallback true})
          :desc "Format buffer"}]
  :opts {:formatters {:cl-indentify {:command :cl-indentify :args [:-r]}}
         :formatters_by_ft {:fennel [:fnlfmt]
                            :lisp [:cl-indentify]
                            :lua [:stylua]
                            :c [:clang_format]
                            :cpp [:clang_format]
                            :markdown [:markdownlint-cli2]}}}]
