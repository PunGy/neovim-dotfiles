(import-macros {: cmd$} :utils.exec)

[{1 :stevearc/oil.nvim
  :lazy false
  :keys [[:<leader>e (cmd$ :Oil) :desc "Navigate file system"]]
  :opts {:default_file_explorer true :view_options {:show_hidden true}}}
 {1 :ibhagwan/fzf-lua
  :opts {:winopts {:preview {:layout :vertical}}}
  :keys [[:<leader>ff (cmd$ "FzfLua files") :desc "Find files"]
         [:<leader>fb (cmd$ "FzfLua buffers") :desc "Find buffers"]]}]
