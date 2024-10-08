return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {},
        ts_ls = { enabled = false },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "ts_ls" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },

      inlay_hints = {
        enabled = false,
        exclude = { "vue" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        elm = { "elm_format" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- general
        "shellcheck",

        "haskell-language-server",
        -- lua
        "stylua",
        "selene",
        "luacheck",
        -- sh
        "shfmt",
        -- web
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        -- Go
        "gofumpt",
        "goimports",
        "gomodifytags",
        "golangci-lint",
        "gotests",
        "iferr",
        "impl",

        -- configs
        "lemminx",
      })
    end,
  },
}
