(import-macros {: plug-setup!} :macros.vim)

(local light :lunaperche)
(local dark :lunaperche)

(fn apply [scheme background]
  (set vim.o.background background)
  (vim.cmd (.. "colorscheme " scheme)))

[{1 :miikanissi/modus-themes.nvim
  :priority 1000
  :lazy false
  :config (fn []
            (plug-setup! :modus-themes {:line_nr_column_background false})
            ;; Runtime swap — replaces the env-driven boot logic.
            (vim.api.nvim_create_user_command :Light #(apply light :light)
                                              {:desc "Switch to modus light"})
            (vim.api.nvim_create_user_command :Dark #(apply dark :dark)
                                              {:desc "Switch to modus dark"})
            (let [theme vim.env.THEME]
              (apply (if (= :light theme) light dark) theme)))}]
