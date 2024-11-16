(import-macros {: g!} :hibiscus.vim)
(import-macros {: plug!} :utils.macros)

(local lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim))

(when (not ((. (or vim.uv vim.loop) :fs_stat) lazypath))
  (local lazyrepo "https://github.com/folke/lazy.nvim.git")
  (local out (vim.fn.system [:git
                             :clone
                             "--filter=blob:none"
                             :--branch=stable
                             lazyrepo
                             lazypath]))
  (when (not= vim.v.shell_error 0)
    (vim.api.nvim_echo [["Failed to clone lazy.nvim:\n" :ErrorMsg]
                        [out :WarningMsg]
                        ["\nPress any key to exit..."]]
                       true {})
    (vim.fn.getchar)
    (os.exit 1)))

(g! maplocalleader "\\")
(g! mapleader " ")

(vim.opt.rtp:prepend lazypath)

(plug! :lazy :setup
       {:checker {:enabled false}
        :spec [{:import :plugins}]
        :rocks {:hererocks true}
        :icons {:cmd " "
                :config ""
                :event " "
                :favorite " "
                :ft " "
                :init " "
                :import " "
                :keys " "
                :lazy "󰒲 "
                :loaded "●"
                :not_loaded "○"
                :plugin " "
                :runtime " "
                :require "󰢱 "
                :source " "
                :start " "
                :task "✔ "
                :list ["●" ">" "★" "‒"]}})
