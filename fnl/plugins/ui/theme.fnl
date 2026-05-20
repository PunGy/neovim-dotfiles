(import-macros {: plug-setup!} :macros.vim)

[{1 :miikanissi/modus-themes.nvim
  :priority 1000
  :config (fn [_ opts]
            (plug-setup! :modus-themes {:line_nr_column_background false})
            (if (= vim.env.THEME :light)
                (vim.cmd "colorscheme modus_operandi")
                (vim.cmd "colorscheme modus_vivendi")))}]
