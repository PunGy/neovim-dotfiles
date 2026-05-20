(import-macros {: plug! : cmd!} :macros.vim)

[{1 :stevearc/oil.nvim
  :lazy false
  :keys [{1 :<leader>e 2 (cmd! :Oil) :desc "Navigate file system"}]
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
  :cmd :FzfLua
  :keys [{1 :<leader>ff 2 (cmd! "FzfLua files") :desc "Find files"}
         {1 :<leader>fb 2 (cmd! "FzfLua buffers") :desc "Find buffers"}
         {1 :<leader>fs 2 (cmd! "FzfLua resume") :desc "Resume previous find"}
         {1 :<leader>ss
          2 (cmd! "FzfLua lsp_document_symbols")
          :desc "Search for a symbol here"}
         {1 :<leader>sb 2 (cmd! "FzfLua lines") :desc "Search in buffers"}
         {1 :<leader>sw
          2 (cmd! "FzfLua lsp_workspace_symbols")
          :desc "Search for a symbol in project"}
         {1 :<leader>sg 2 (cmd! "FzfLua live_grep") :desc "Grep project"}
         {1 :<leader>/ 2 (cmd! "FzfLua blines") :desc "Search here"}
         {1 :<leader>df
          2 (cmd! "FzfLua diagnostics_document")
          :desc "File Diagnostics"}]}
 {1 :andymass/vim-matchup}
 {1 :MagicDuck/grug-far.nvim
  :opts {:headerMaxWidth 80}
  :keys [{1 :<leader>sr
          2 #(plug! :grug-far :open
                    {:transient true
                     :prefills {:filesFilter (or (and ext (not= ext "")
                                                      (.. "*." ext))
                                                 nil)}})
          :desc "Find and replace in project"}]}]
