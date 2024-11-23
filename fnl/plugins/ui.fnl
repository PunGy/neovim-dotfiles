(import-macros {: map! : exec!} :hibiscus.vim)
(import-macros {: plug! : plug$ : cmd$} :utils.macros)
(local {: file-explorer : close-buffer} (require :utils.ui))

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
  :opts {:options {:diagnostics :nvim_lsp
                   :show_buffer_close_icons false
                   :close_command #(close-buffer $1 {:silent true})
                   ;:groups {:items [((. (require :bufferline.groups) :builtin
                   ;                     :pinned ):with {:icon "󰐃 "})]}
                   }}
  :config (fn [_ opts]
            (local bufferline (require :bufferline))
            (bufferline.setup opts))}
 ;; Theme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  :init (fn [] (exec! [colorscheme kanagawa]))
  :opts {:commentStyle {:italic false}
         :overrides (fn [colors]
                      (local {: palette :theme {: ui}} colors)
                      {:NeoTreeNormal {:fg ui.fg :bg ui.float.bg}
                       :NeoTreeFloatBorder {:fg ui.float.bg :bg ui.float.bg}
                       :DashboardHeader {:fg palette.oniViolet}
                       :DashboardShortCut {:fg palette.oniViolet}
                       :DashboardKey {:fg palette.samuraiRed}
                       :WhichKeySeparator {:fg palette.katanaGray
                                           :italic false}})}}
 ;; Search and replace
 {1 :MagicDuck/grug-far.nvim
  :config (fn [] (plug! :grug-far :setup {:headerMaxWidth 80}))}
 ;; Images
 {1 :3rd/image.nvim
  :opts {:processor :magick_cli
         :backend :kitty
         :kitty_method :normal
         :integrations {:markdown {:enabled true
                                   :dowload_remote_images true
                                   :filetypes [:markdown]}}
         :integration {}
         :max_width nil
         :max_height nil
         :max_width_window_percentage nil
         :max_height_window_percentage 40
         :window_overlap_clear_enabled true
         :window_overlap_clear_ft_ignore [:cmp_menu :cmp_docs ""]
         :editor_only_render_when_focused true
         :tmux_show_only_in_active_window true
         :hijack_file_patterns [:*.png :*.jpg :*.jpeg :*.gif :*.webp :*.avif]}}
 {1 :HakonHarnes/img-clip.nvim :event :VeryLazy}
 ;; Misc
 {1 :brenoprata10/nvim-highlight-colors :lazy true}
 {1 :folke/which-key.nvim :dependencies [:echasnovski/mini.icons]}
 {1 :mbbill/undotree}
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
