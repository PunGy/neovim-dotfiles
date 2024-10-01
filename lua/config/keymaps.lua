-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

local opts = {
  noremap = true,
  silent = true,
}

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

keymap.set("n", "<leader>h", vim.cmd.UndotreeToggle)

keymap.set("n", "<leader>bn", function()
  local bufname = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t")

  vim.fn.setreg("+", bufname)
end)
keymap.set("n", "<leader>bc", function()
  local cwd_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")

  vim.fn.setreg("+", cwd_path)
end)
