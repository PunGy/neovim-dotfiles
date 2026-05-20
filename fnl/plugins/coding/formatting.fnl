(import-macros {: plug!} :macros.vim)

[{1 :stevearc/conform.nvim
  :keys [[:<C-f>
          #(plug! :conform :format {:lsp_fallback true})
          :desc
          "Format buffer"]]
  :opts {:formatters {:cl-indentify {:command :cl-indentify :args [:-r]}}
         :formatters_by_ft {:fennel [:fnlfmt]
                            :lisp [:cl-indentify]
                            :lua [:stylua]
                            :c [:clang_format]
                            :cpp [:clang_format]
                            :markdown [:markdownlint-cli2]}}}]
