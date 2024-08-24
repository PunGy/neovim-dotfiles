return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- general
        "gitignore",

        -- web
        "css",
        "astro",
        "http",
        "scss",
        "svelte",

        -- CPP
        "cmake",

        -- Languages
        "cpp",
        "go",
        "rust",
        "sql",
      },
    },
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    -- end,
  },
}
