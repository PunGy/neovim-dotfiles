(import-macros {: cmd$} :macros.exec)
(import-macros {: plug!} :macros.vim)

[{1 :stevearc/oil.nvim
  :lazy false
  :keys [[:<leader>e (cmd$ :Oil) :desc "Navigate file system"]]
  :opts {:default_file_explorer true
         :view_options {:show_hidden true}
         :keymaps {:g? {1 :actions.show_help :mode :n}
                   :<CR> :actions.select
                   :<C-v> {1 :actions.select :opts {:vertical true}}
                   :<C-h> {1 :actions.select :opts {:horizontal true}}
                   :<C-t> {1 :actions.select :opts {:tab true}}
                   :<C-p> :actions.preview
                   :<C-c> {1 :actions.close :mode :n}
                   :<C-l> :actions.refresh
                   :- {1 :actions.parent :mode :n}
                   :_ {1 :actions.open_cwd :mode :n}
                   "`" {1 :actions.cd :mode :n}
                   "~" {1 :actions.cd :opts {:scope :tab} :mode :n}
                   :gs {1 :actions.change_sort :mode :n}
                   :gx :actions.open_external
                   :g. {1 :actions.toggle_hidden :mode :n}
                   "g\\" {1 :actions.toggle_trash :mode :n}}
         :use_default_keymaps false}}
 {1 :ibhagwan/fzf-lua
  :opts {:winopts {:preview {:layout :vertical}}}
  :keys [[:<leader>ff (cmd$ "FzfLua files") :desc "Find files"]
         [:<leader>fb (cmd$ "FzfLua buffers") :desc "Find buffers"]
         [:<leader>fs (cmd$ "FzfLua resume") :desc "Resume previous find"]
         [:<leader>ss
          (cmd$ "FzfLua lsp_document_symbols")
          :desc
          "Search for a symbol here"]
         [:<leader>sb (cmd$ "FzfLua lines") :desc "Search in buffes"]
         [:<leader>sw
          (cmd$ "FzfLua lsp_workspace_symbols")
          :desc
          "Search for a symbol in project"]
         [:<leader>sg (cmd$ "FzfLua live_grep") :desc "Grep project"]
         [:<leader>/ (cmd$ "FzfLua blines") :desc "Search here"]
         [:<leader>df (cmd$ "FzfLua diagnostics_document") :desc "File Diagnostics"]]}
 {1 :andymass/vim-matchup}
 {1 :MagicDuck/grug-far.nvim
  :opts {:headerMaxWidth 80}
  :keys [[:<leader>sr
          #(plug! :grug-far :open
                  {:transient true
                   :prefills {:filesFilter (or (and ext (not= ext "")
                                                    (.. "*." ext))
                                               nil)}})
          :desc
          "Find and replace in project"]]}]
