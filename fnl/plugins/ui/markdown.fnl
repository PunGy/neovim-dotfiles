(import-macros {: cmd!} :macros.vim)

[{1 :iamcco/markdown-preview.nvim
  :cmd [:MarkdownPreviewToggle :MarkdownPreview :MarkdownPreviewStop]
  :keys [{1 :<leader>ump 2 (cmd! :MarkdownPreview)
          :desc "Start markdown preview"}
         {1 :<leader>umt 2 (cmd! :MarkdownPreviewToggle)
          :desc "Toggle markdown preview"}
         {1 :<leader>ums 2 (cmd! :MarkdownPreviewStop)
          :desc "Stop markdown preview"}]
  :ft [:markdown]
  :init (fn [] (set vim.g.mkdp_filetypes [:markdown]))
  :build "cd app && yarn install"}]
