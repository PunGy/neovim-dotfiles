(import-macros {: dump! : nil?} :hibiscus.core)
(import-macros {: map!} :hibiscus.vim)
(import-macros {: plug! : plug$} :utils.macros)

(fn plugin-opts [name]
  (let [plugin (. (require :lazy.core.config) :spec :plugins name)]
    (if plugin
        ((. (require :lazy.core.plugin) :values) plugin :opts false)
        {})))

[;; LSP
 {1 :neovim/nvim-lspconfig
  :event [:BufReadPost :BufWritePost :BufNewFile]
  :dependencies [:williamboman/mason.nvim
                 :williamboman/mason-lspconfig.nvim
                 :hrsh7th/cmp-nvim-lsp
                 :hrsh7th/cmp-buffer
                 :hrsh7th/cmp-path
                 :hrsh7th/cmp-cmdline
                 :hrsh7th/nvim-cmp
                 :PaterJason/cmp-conjure]
  :opts (fn []
          {:diagnostics {:severity_sort true
                         :signs {:text [" " " " " " " "]}
                         :underline true
                         :update_in_insert false
                         :virtual_text {:prefix "●"
                                        :source :if_many
                                        :spacing 4}}
           :servers {:eslint {:settings {:workingDirectories {:mode :auto}}
                              :on_attach (fn [client]
                                           (set client.server_capabilities.documentFormattingProvider
                                                true))}
                     :ts_ls {:on_attach (fn [client]
                                          (set client.server_capabilities.documentFormattingProvider
                                               false))
                             :init_options {:importModuleSpecifierPreference :relative}}
                     :neocmake {}
                     :clangd {:cmd [:clangd :--background-index :--clang-tidy]}
                     :marksman {:on_attach (fn [client]
                                             (if (pcall require :zk)
                                                 (client.stop)))}}
           :setup {:arduino_language_server (fn [server]
                                              ((. (require :lspconfig) server :setup) {:cmd [:arduino-language-server
                                                                                      :-clangd :/usr/bin/clangd
                                                                                      :-cli :/home/pungy/.local/share/bin/arduino-cli
                                                                                      :-cli-config :/home/pungy/.arduino15/arduino-cli.yaml
                                                                                      :-fqbn :arduino:avr:uno]}))}})
  ;; Almost entirely copied form LazyVim - refactor to be more simple and lispy
  :config (fn [_ opts]
            (local {: servers} opts)
            (local cmp (require :cmp))
            (local cmp-lsp (require :cmp_nvim_lsp))
            (local capabilities
                   (vim.tbl_deep_extend :force {}
                                        (vim.lsp.protocol.make_client_capabilities)
                                        (cmp-lsp.default_capabilities)))
            ;; Server setup fn (TODO: refactor and simplify)

            (fn setup [server]
              ;(print "Settuping server:" server)
              (let [server-opts (vim.tbl_deep_extend :force
                                                     {:capabilities (vim.deepcopy capabilities)}
                                                     (or (. servers server) {}))]
                (when (= server-opts.enabled false) (lua "return "))
                (if (. opts.setup server)
                    ((. opts.setup server) server server-opts)
                    ((. (require :lspconfig) server :setup) server-opts))))

            ;; Connect with mason
            (local (have-mason mlsp) (pcall require :mason-lspconfig))
            (var all-mslp-servers {})
            (when have-mason
              (set all-mslp-servers
                   (vim.tbl_keys (. (require :mason-lspconfig.mappings.server)
                                    :lspconfig_to_package))))
            (local ensure-installed {})
            (each [server server-opts (pairs servers)]
              (when server-opts
                (set-forcibly! server-opts
                               (or (and (= server-opts true) {}) server-opts))
                (when (not= server-opts.enabled false)
                  (if (or (= server-opts.mason false)
                          (not (vim.tbl_contains all-mslp-servers server)))
                      (setup server)
                      (tset ensure-installed (+ (length ensure-installed) 1)
                            server)))))
            (when have-mason
              (mlsp.setup {:ensure_installed (vim.tbl_deep_extend :force
                                                                  ensure-installed
                                                                  (or (. (plugin-opts :mason-lspconfig.nvim)
                                                                         :ensure_installed)
                                                                      {}))
                           :handlers [setup]}))
            ;; Configure cmp
            (local cmp-select {:behavior cmp.SelectBehavior.Select})
            (cmp.setup {:mapping (cmp.mapping.preset.insert {:<A-Return> (cmp.mapping.complete)
                                                             :<C-n> (cmp.mapping.select_next_item cmp-select)
                                                             :<C-p> (cmp.mapping.select_prev_item cmp-select)
                                                             :<C-Return> (cmp.mapping.confirm {:select true})})
                        :snippet {:expand (fn [args]
                                            ((. (require :luasnip) :lsp_expand) args.body))}
                        :sources (cmp.config.sources [{:name :nvim_lsp}]
                                                     [{:name :buffer}]
                                                     [{:name :conjure}])})
            (vim.diagnostic.config {:float {:border :rounded
                                            :focusable false
                                            :header ""
                                            :prefix ""
                                            :source :always
                                            :style :minimal}}))}
 ;; MASON
 {1 :williamboman/mason.nvim
  :version :^1.0.0
  :cmd :Mason
  :build ":MasonUpdate"
  :opts_extend [:ensure_installed]
  :opts {:ensure_installed [;; general
                            :shellcheck
                            ;; Note taking
                            :markdownlint-cli2
                            ;; Microcontrollers
                            :arduino-language-server
                            :asm-lsp
                            ;; C/CPP
                            :clangd
                            :clang-format
                            :codelldb
                            :cmakelang
                            :cmakelint
                            ;; lua
                            :stylua
                            :selene
                            :luacheck
                            ;; sh
                            :shfmt
                            ;; web
                            ;;:tailwindcss-language-server
                            :typescript-language-server
                            :css-lsp
                            :eslint-lsp
                            :astro-language-server
                            ;; Python
                            :pyright
                            ;; Java
                            :jdtls
                            ;; Go
                            :gofumpt
                            :goimports
                            :gomodifytags
                            :golangci-lint
                            :gotests
                            :iferr
                            :impl
                            ;; Haskell
                            :haskell-language-server
                            ;; Lisp
                            ;:fennel-language-server
                            ;:fennel-ls
                            ;; configs
                            :lemminx]}
  :config (fn [_ opts]
            ((. (require :mason) :setup) opts)
            (local mr (require :mason-registry))
            (mr:on "package:install:success"
                   (fn []
                     (vim.defer_fn (fn []
                                     ((. (require :lazy.core.handler.event)
                                         :trigger) {:buf (vim.api.nvim_get_current_buf)
                                                                                                                                :event :FileType}))
                       100)))
            (mr.refresh (fn []
                          (each [_ tool (ipairs opts.ensure_installed)]
                            (local p (mr.get_package tool))
                            (when (not (p:is_installed)) (p:install))))))}
 {1 :williamboman/mason-lspconfig.nvim
  :version :^1.0.0}
 {1 :jay-babu/mason-nvim-dap.nvim
  :event [:VeryLazy]
  :dependencies [:williamboman/mason.nvim :mfussenegger/nvim-dap]
  :opts {:handlers {} :ensure_installed [:codelldb]}}
 {1 :rcarriga/nvim-dap-ui
  :dependencies [:mfussenegger/nvim-dap :nvim-neotest/nvim-nio]
  :event [:VeryLazy]
  :config (fn []
            (let [dap (require :dap)
                  dapui (require :dapui)]
              (dapui.setup)

              (fn dap.listeners.after.event_initialized.dapui_config []
                (dapui.open))

              (fn dap.listeners.before.event_terminated.dapui_config []
                (dapui.close))

              (fn dap.listeners.before.event_exited.dapui_config []
                (dapui.close))))}
 {1 :mfussenegger/nvim-dap}
 ;; Conjure
 {1 :Olical/conjure}
 ;; Cmake
 {1 :Civitasv/cmake-tools.nvim :event [:VeryLazy]}
 ;; Formatting
 {1 :stevearc/conform.nvim
  :cmd [:ConformInfo]
  :lazy false
  :dependencies [:williamboman/mason.nvim]
  :config (fn []
            (local conform (require :conform))
            (conform.setup {})
            ;(conform.setup {:format_on_save {:timeout_ms 500 ;                                 :lsp_format :fallback}})
            ;(tset conform :formatters ;      {:markdownlint-cli2 {:condition (fn [_ ctx] ;                                        (let [diag (vim.tbl_filter (fn [d]
            ;                                                                     (= d.source
            ;                                                                        :markdownlint))
            ;                                                                   (vim.diagnostic.get ctx.buf))]
            ;                                          (> (length diag) 0)))}})
            (tset conform :formatters
                  {:cl-indentify {:command :cl-indentify :args [:-r]}})
            (tset conform :formatters_by_ft
                  {:fennel [:fnlfmt]
                   :lisp [:cl-indentify]
                   :lua [:stylua]
                   :c [:clang_format]
                   :cpp [:clang_format]
                   :markdown [:markdownlint-cli2]})
            (conform.list_formatters)
            (map! [n :remap] :<C-f>
                  (fn []
                    (let [buf (vim.api.nvim_get_current_buf)]
                      (if (nil? (next (conform.list_formatters)))
                          (vim.lsp.buf.format)
                          (conform.format {:bufnr buf}))))))}
 {1 :mfussenegger/nvim-lint
  :event [:BufReadPost :BufWritePost :BufNewFile]
  :config (fn [_ opts]
            (local lint (require :lint))
            (tset lint :linters_by_ft {:fish [:fish]}))}
 ;; Navigating
 {1 :folke/flash.nvim
  :event [:VeryLazy]
  :config (fn []
            (plug! :flash :setup {})
            (map! [nxo] :s (plug$ :flash :jump))
            (map! [nxo] :S (plug$ :flash :treesitter)))}
 ;; Editing
 {1 :L3MON4D3/LuaSnip}
 {1 :ThePrimeagen/refactoring.nvim}
 {1 :echasnovski/mini.surround
  :version "*"
  :event [:VeryLazy]
  :opts {:mappings {:add :gsa
                    :delete :gsr
                    :find :gsf
                    :find_left :gsF
                    :delete :gsr}}}]

