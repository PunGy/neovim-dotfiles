(import-macros {: map! : exec!} :hibiscus.vim)
(import-macros {: plug! : plug$ : cmd$} :utils.macros)
(local {: file-explorer} (require :utils.ui))

(local lain
       ["⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⣉⣢⣤⣤⣤⣤⣴⣶⣤⣤⣄⣈⠙⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢁⣠⣴⣿⡏⢀⣠⣿⣿⣿⣿⡿⠿⠿⠿⢿⣧⣀⣁⡨⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⡑⠄⠤⠒⣉⢀⣴⣿⣿⣿⣿⣿⣿⠿⢛⣩⣥⣶⣶⣶⣾⣷⣶⣦⣍⡛⢿⣦⡐⠉⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⡟⢀⣴⠃⣤⣶⣶⠖⣸⣿⣿⣿⣿⣿⣿⠋⣡⣾⣿⣿⣿⣿⣿⣇⠀⠀⠀⠈⣻⣿⣦⡙⢿⣄⠳⢀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⢀⢸⡧⢸⣿⣿⠏⣸⣿⣿⣿⣿⣿⠟⣡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣴⣿⣿⣿⣿⣄⢻⣦⠠⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⡆⠈⠃⠀⠙⠟⠀⠉⠀⠀⠀⠛⠟⢰⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠿⠿⠿⢿⣿⣿⣿⣆⢻⣆⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⡈⠋⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢹⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⡄⠀⠀⠀⡇⣼⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⢸⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣇⠀⣷⠀⢀⡀⡇⢹⣿⡇⢸⢀⣀⠀⢸⠀⣀⡀⠀⠀⠀⠀⠀⠀⡇⢸⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣘⣩⣤⣤⣤⣤⢤⡠⣸⣿⡇⣿⣾⣿⡃⠨⡄⣉⣉⡀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠠⠀⠀⠀⠀⠀⠀⠀⠀⠐⣿⣿⠟⠉⠠⠀⠌⣁⣿⣿⣿⣷⣿⣿⣿⠃⡉⡉⠉⡛⢿⡇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠸⣧⣶⣄⣿⣿⣶⡑⠄⠀⣀⣿⣿⣿⣿⣿⣿⣿⣿⣯⡣⠀⠠⠗⣿⠁⠀⣠⡀⡇⢸⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⢠⣶⡟⣿⠡⢸⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⢸⣿⣷⠸⠀⠸⣿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⡄⢠⡀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⣿⣿⣿⣧⠀⠁⢿⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⢀⣾⣷⣾⣿⣦⣸⣷⣌⣷⣦⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⣁⠀⠀⠀⣿⣿⣿⣿⣧⠀⠌⣿⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣬⡙⠿⢿⣿⣿⡿⠟⣋⢥⣾⣿⣿⠀⠀⠀⣿⣿⣿⣿⣿⣧⡀⡸⣿⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣔⠢⡴⢂⣜⣵⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠹⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⢀⡄⠀⠈⠛⢿⣿⣿⡇⠀⠀⢸⣿⣿⣿⣿⣿⣿⡷⠁⣿⣿⣿⣿"
        "⣿⣿⣿⣿⣿⠃⠁⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠉⠣⠀⠀⢸⣿⣿⣿⣿⣿⡟⠁⣰⣿⣿⣿⣿"
        "⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⠿⠋⠀⠌⢿⣿⣿⣿⣿"
        "⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠜⣿⣿⣿⣿"
        "⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿"
        "⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿"
        "⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀ ⠀⠀⠀▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖⠀      ⠀⠀⠀⠀⠀⠀⠊⣿⣿"
        "⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀ ⠀⠀⠀▐▌  ▐▌  █  ▐▛▚▞▜▌⠀⠀⠀⠀⠀⠀   ⠀⠀⠀⠀⠀⢿⣿"
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀ ⠀⠀⠀▐▌  ▐▌  █  ▐▌  ▐▌⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⠀⢸⣿"
        "⡇⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀ ⠀⠀⠀ ▝▚▞▘ ▗▄█▄▖▐▌  ▐▌⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠀⠸⣿"
        "⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⣿"
        "⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢸"])

[;; File explorers
 {1 :nvim-neo-tree/neo-tree.nvim
  :branch :v3.x
  :dependencies [:nvim-lua/plenary.nvim
                 :nvim-tree/nvim-web-devicons
                 :MunifTanjim/nui.nvim]
  :opts {:filesystem {:window {:position :float}
                      :filtered_items {:visible true
                                       :show_hidden_count true
                                       :hide_dotfiles false
                                       :hide_gitignored true
                                       :hide_by_name {:.git :.DS_Store}
                                       :never_show {}}}
         :popup_border_style :rounded}}
 {1 :ibhagwan/fzf-lua :dependencies [:nvim-tree/nvim-web-devicons]}
 ;; Workspace UI
 {1 :akinsho/bufferline.nvim
  :dependencies [:nvim-tree/nvim-web-devicons]
  :opts {:options {:diagnostics :nvim_lsp}}
  :config (fn [_ opts]
            (plug! :bufferline :setup opts))}
 ;; Theme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  :init (fn [] (exec! [colorscheme kanagawa]))
  :opts {:overrides (fn [colors]
                      (local {: palette :theme {: ui}} colors)
                      {:NeoTreeNormal {:fg ui.fg :bg ui.float.bg}
                       :NeoTreeFloatBorder {:fg ui.float.bg :bg ui.float.bg}
                       :DashboardHeader {:fg palette.oniViolet}
                       :DashboardShortCut {:fg palette.oniViolet}
                       :DashboardKey {:fg palette.samuraiRed}
                       :WhichKeyIconGrey {:fg "#000000"}})}}
 ;; Search and replace
 {1 :MagicDuck/grug-far.nvim
  :config (fn [] (plug! :grug-far :setup {:headerMaxWidth 80}))}
 ;; Misc
 {1 :brenoprata10/nvim-highlight-colors :lazy true}
 {1 :folke/which-key.nvim :dependencies [:echasnovski/mini.icons]}
 {1 :mbbill/undotree}
 {1 :3rd/image.nvim}
 {1 :nvimdev/dashboard-nvim
  :event :VimEnter
  :opts {:theme :doom
         ;:hide {:statusline false}
         :config {:header lain
                  :center [{:desc " File Explorer"
                            :icon " "
                            :keymap "SPC e"
                            :key :e
                            :action file-explorer}
                           {:desc " Find File"
                            :icon "󰈞 "
                            :keymap "SPC f f"
                            :key :f
                            :action (fn []
                                      (vim.api.nvim_input (cmd$ "FzfLua files")))}
                           {:desc " Restore last session"
                            :icon " "
                            :keymap "C-x l"
                            :key :l
                            :action (plug$ :persistence :load {:last true})}
                           {:desc " Quit"
                            :icon " "
                            :keymap "C-x q"
                            :key :q
                            :action (fn [] (vim.api.nvim_input (cmd$ :qa)))}]
                  :footer []}}}]
