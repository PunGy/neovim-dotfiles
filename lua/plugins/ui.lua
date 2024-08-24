return {
  -- undo tree
  {
    "mbbill/undotree",
  },
  -- notifications
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information",
        },
        opts = { skip = true },
      })
      opts.presets.lsp_doc_border = true
    end,
  },
  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "catppuccin/nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("catppuccin.palettes.mocha")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.blue, guifg = colors.crust },
            InclineNormalNC = { guibg = colors.surface0, guifg = colors.subtext0 },
          },
        },
        window = {
          margin = { vertical = 0, horizontal = 0 },
          padding = 0,
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          if vim.bo[props.buf].modified then
            filename = "[+]" .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return {
            icon and { " ", icon, " ", guibg = color, guifg = colors.crust } or "",
            " ",
            { filename },
            " ",
          }
        end,
      })
    end,
  },
  -- animations
  {
    "echasnovski/mini.animate",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        cursor = {
          enable = false,
        },
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },
  -- bufferline --
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<C-x>", "<Cmd>bdelete<CR>", desc = "Delete buffer" },
    },
  },

  -- neo tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ reveal = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree",
      },
      {
        "<leader>fd",
        function()
          require("neo-tree.command").execute({ source = "document_symbols", toggle = true })
        end,
        desc = "Explore file structure",
      },
    },
    opts = {
      filesystem = {
        window = {
          position = "float",
        },
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            ".DS_Store",
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    },
  },

  -- logo
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[

 ██▓███   █    ██  ███▄    █   ▄████▓██   ██▓
▓██░  ██▒ ██  ▓██▒ ██ ▀█   █  ██▒ ▀█▒▒██  ██▒
▓██░ ██▓▒▓██  ▒██░▓██  ▀█ ██▒▒██░▄▄▄░ ▒██ ██░
▒██▄█▓▒ ▒▓▓█  ░██░▓██▒  ▐▌██▒░▓█  ██▓ ░ ▐██▓░
▒██▒ ░  ░▒▒█████▓ ▒██░   ▓██░░▒▓███▀▒ ░ ██▒▓░
▒▓▒░ ░  ░░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒  ░▒   ▒   ██▒▒▒ 
░▒ ░     ░░▒░ ░ ░ ░ ░░   ░ ▒░  ░   ░ ▓██ ░▒░ 
░░        ░░░ ░ ░    ░   ░ ░ ░ ░   ░ ▒ ▒ ░░  
            ░              ░       ░ ░ ░     
                                     ░ ░     
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
