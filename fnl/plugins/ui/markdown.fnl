(local {: cmd} (require :utils.exec))

[{1 :iamcco/markdown-preview.nvim
  :cmd [:MarkdownPreviewToggle :MarkdownPreview :MarkdownPreviewStop]
  :keys [[:<leader>ump (cmd :MarkdownPreview) :desc "Start markdown preview"]
         [:<leader>umt
          (cmd :MarkdownPreviewToggle)
          :desc
          "Toggle markdown preview"]
         [:<leader>ums
          (cmd :MarkdownPreviewStop)
          :desc
          "Stop markdown preview"]]
  :ft [:markdown]
  :init (fn [] (set vim.g.mkdp_filetypes [:markdown]))
  :build "cd app && yarn install"}]
