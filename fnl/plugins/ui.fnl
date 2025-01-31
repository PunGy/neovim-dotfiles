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
 {1 :ibhagwan/fzf-lua
  :dependencies [:nvim-tree/nvim-web-devicons]
  :opts {:winopts {:preview {:layout :vertical}}}
  :config (fn [_ opts]
            (local fzf (require :fzf-lua))
            (local actions fzf.actions)
            (fzf.setup opts)
            ;; Fzf pinned previwer
            (local builtin (require :fzf-lua.previewer.builtin))
            (local PinnedPreviewer (builtin.buffer_or_file:extend))

            (fn PinnedPreviewer.new [self o opts fzf-win]
              (PinnedPreviewer.super.new self o opts fzf-win)
              (setmetatable self PinnedPreviewer)
              self)

            (fn PinnedPreviewer.parse_entry [self entry-str]
              (let [(path line) (entry-str:match "([^:]+):?(.*)")]
                {:col 1 :line (or (tonumber line) 1) : path}))

            (map! [n] :<leader>fp
                  (fn []
                    (let [pinned (. (: (require :harpoon) :list) :items)]
                      (plug! :fzf-lua :fzf_exec
                             (icollect [_ cfg (ipairs pinned)]
                               (.. cfg.value ":" cfg.context.row))
                             {:prompt "Pinned> "
                              :previewer PinnedPreviewer
                              :actions {:default actions.file_edit}})))
                  "Find pinned"))}
 {1 :ThePrimeagen/harpoon :branch :harpoon2}
 ;; Workspace UI
 ;; Theme
 {1 :rebelot/kanagawa.nvim
  :lazy false
  ;:init (fn [] (exec! [colorscheme kanagawa]))
  :opts {:commentStyle {:italic false}
         :undercurl true
         :keywordStyle {:italic true}
         :overrides (fn [colors]
                      (local {: palette :theme {: ui}} colors)
                      {:NeoTreeNormal {:fg ui.fg :bg ui.float.bg}
                       :NeoTreeFloatBorder {:fg ui.float.bg :bg ui.float.bg}
                       :DashboardHeader {:fg palette.oniViolet}
                       :DashboardShortCut {:fg palette.oniViolet}
                       :DashboardKey {:fg palette.samuraiRed}
                       :WhichKeySeparator {:fg palette.katanaGray
                                           :italic false}})}}
 {1 :neanias/everforest-nvim
  :lazy false
  :priority 1000
  :init (fn [] (exec! [colorscheme everforest]))
  :config (fn []
            (exec! [set background=dark])
            (plug! :everforest :setup {:background :hard :italics true}))}
 {1 :seandewar/paragon.vim
  :lazy false
  :priority 1000
  ;:init (fn []
  ;        (exec! [set background=light])
  ;        (exec! [colorscheme paragon]))
  ;:config (fn []
  ;          (exec! ))
  }
 {1 :nyoom-engineering/oxocarbon.nvim
  :lazy false
  :priority 1000
  ;:init (fn []
  ;        (exec! [set background=light])
  ;        (exec! [colorscheme oxocarbon]))
  }
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
