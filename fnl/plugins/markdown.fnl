[{1 :iamcco/markdown-preview.nvim
  :cmd [:MarkdownPreviewToggle :MarkdownPreview :MarkdownPreviewStop]
  :ft [:markdown]
  :build (fn [] ((. vim.fn "mkdp#util#install")))}
 {1 :MeanderingProgrammer/render-markdown.nvim
  :opts {:pipe_table {:style :normal} :code {:style :normal :border :thick}}}]
