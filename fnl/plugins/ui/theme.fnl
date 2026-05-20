(import-macros {: plug-setup!} :macros.vim)

(local light :modus_operandi)
(local dark :modus_vivendi)

(fn apply [scheme]
  (set vim.o.background (if (= scheme light) :light :dark))
  (vim.cmd (.. "colorscheme " scheme)))

[{1 :miikanissi/modus-themes.nvim
  :priority 1000
  :lazy false
  :config (fn []
            (plug-setup! :modus-themes {:line_nr_column_background false})
            ;; Runtime swap — replaces the env-driven boot logic.
            (vim.api.nvim_create_user_command :Light #(apply light)
                                              {:desc "Switch to modus light"})
            (vim.api.nvim_create_user_command :Dark #(apply dark)
                                              {:desc "Switch to modus dark"})
            (apply (if (= vim.env.THEME :light) light dark)))}]
