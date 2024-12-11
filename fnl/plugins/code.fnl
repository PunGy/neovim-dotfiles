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
                 :hrsh7th/nvim-cmp]
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
                     :marksman {}}
           :setup {}})
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
                    (when ((. opts.setup server) server server-opts)
                      (lua "return "))
                    (. opts.setup "*")
                    (when ((. opts.setup "*") server server-opts)
                      (lua "return ")))
                ((. (require :lspconfig) server :setup) server-opts)))

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
            (cmp.setup {:mapping (cmp.mapping.preset.insert {:<A-Space> (cmp.mapping.complete)
                                                             :<C-n> (cmp.mapping.select_next_item cmp-select)
                                                             :<C-p> (cmp.mapping.select_prev_item cmp-select)
                                                             :<C-Return> (cmp.mapping.confirm {:select true})})
                        :snippet {:expand (fn [args]
                                            ((. (require :luasnip) :lsp_expand) args.body))}
                        :sources (cmp.config.sources [{:name :nvim_lsp}]
                                                     [{:name :buffer}])})
            (vim.diagnostic.config {:float {:border :rounded
                                            :focusable false
                                            :header ""
                                            :prefix ""
                                            :source :always
                                            :style :minimal}}))}
 ;; MASON
 {1 :williamboman/mason.nvim
  :cmd :Mason
  :build ":MasonUpdate"
  :opts_extend [:ensure_installed]
  :opts {:ensure_installed [;; general
                            :shellcheck
                            ;; Note taking
                            :markdownlint-cli2
                            ;; C/CPP
                            :clangd
                            :clang-format
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
                            ;; Python
                            :pyright
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
 ;; Formatting
 {1 :stevearc/conform.nvim
  :cmd [:ConformInfo]
  :lazy false
  :dependencies [:williamboman/mason.nvim]
  :config (fn []
            (local conform (require :conform))
            (conform.setup {})
            ;(conform.setup {:format_on_save {:timeout_ms 500 ;                                 :lsp_format :fallback}})
            ;(tset conform :formatters
            ;      {:markdownlint-cli2 {:condition (fn [_ ctx]
            ;                                        (let [diag (vim.tbl_filter (fn [d]
            ;                                                                     (= d.source
            ;                                                                        :markdownlint))
            ;                                                                   (vim.diagnostic.get ctx.buf))]
            ;                                          (> (length diag) 0)))}})
            (tset conform :formatters_by_ft
                  {:fennel [:fnlfmt]
                   :lua [:stylua]
                   :c [:clang_format]
                   :cpp [:clang_format]
                   :markdown [:markdownlint-cli2]})
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
 ;{1 :echasnovski/mini.surround
 ; :version "*"
 ; :event [:VeryLazy]
 ; :opts {:mappings {:add :gsa
 ;                   :delete :gsr
 ;                   :find :gsf
 ;                   :find_left :gsF
 ;                   :delete :gsr}}}
 ]
