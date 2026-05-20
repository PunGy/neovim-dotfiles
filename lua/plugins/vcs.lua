-- [nfnl] fnl/plugins/vcs.fnl
local _local_1_ = require("utils.system")
local is_dir = _local_1_["is-dir"]
local _local_2_ = require("utils.yndx")
local is_in_arcadia = _local_2_["is-in-arcadia"]
local gitsigns_opts
local function _3_(bufnr)
  local gs = require("gitsigns")
  local function _4_()
    return gs.nav_hunk("next")
  end
  vim.keymap.set({"n"}, "]h", _4_, {buffer = true, desc = "Next hunk", silent = true})
  local function _5_()
    return gs.nav_hunk("prev")
  end
  vim.keymap.set({"n"}, "[h", _5_, {buffer = true, desc = "Prev hunk", silent = true})
  vim.keymap.set({"n", "v"}, "<leader>vs", "<cmd>:Gitsigns stage_hunk<cr>", {buffer = true, desc = "Stage Hunk", silent = true})
  vim.keymap.set({"n", "v"}, "<leader>vr", "<cmd>:Gitsigns reset_hunk<cr>", {buffer = true, desc = "Reset Hunk", silent = true})
  vim.keymap.set({"n"}, "<leader>vS", gs.stage_buffer, {buffer = true, desc = "Stage Buffer", silent = true})
  vim.keymap.set({"n"}, "<leader>vu", gs.undo_stage_hunk, {buffer = true, desc = "Undo Stage Hunk", silent = true})
  vim.keymap.set({"n"}, "<leader>vR", gs.reset_buffer, {buffer = true, desc = "Reset Buffer", silent = true})
  vim.keymap.set({"n"}, "<leader>vp", gs.preview_hunk_inline, {buffer = true, desc = "Preview Hunk Inline", silent = true})
  local function _6_()
    return gs.blame_line({full = true})
  end
  vim.keymap.set({"n"}, "<leader>vb", _6_, {buffer = true, desc = "Blame Line", silent = true})
  local function _7_()
    return gs.blame()
  end
  vim.keymap.set({"n"}, "<leader>vB", _7_, {buffer = true, desc = "Blame Buffer", silent = true})
  vim.keymap.set({"n"}, "<leader>vd", gs.diffthis, {buffer = true, desc = "Diff This", silent = true})
  local function _8_()
    return gs.diffthis("~")
  end
  vim.keymap.set({"n"}, "<leader>vD", _8_, {buffer = true, desc = "Diff This ~", silent = true})
  vim.keymap.set({"o", "x"}, "ih", "<cmd>:<C-U>Gitsigns select_hunk<cr>", {buffer = true, desc = "GitSigns Select Hunk", silent = true})
  vim.keymap.set({"n"}, "<leader>vms", "<cmd>terminal git add . && git commit -m $(timestamp) && git push<cr>", {buffer = true, desc = "Save changes and push", silent = true})
  vim.keymap.set({"n"}, "<leader>vmP", "<cmd>terminal git push<cr>", {buffer = true, desc = "Push", silent = true})
  vim.keymap.set({"n"}, "<leader>vmp", "<cmd>terminal git pull<cr>", {buffer = true, desc = "Pull", silent = true})
  vim.keymap.set({"n"}, "<leader>vmh", "<cmd>terminal git stash<cr>", {buffer = true, desc = "Stash changes (hide)", silent = true})
  return vim.keymap.set({"n"}, "<leader>vmu", "<cmd>terminal git stash pop<cr>", {buffer = true, desc = "Unstash changes (unhide)", silent = true})
end
gitsigns_opts = {signs = {add = {text = "\226\150\142"}, change = {text = "\226\150\142"}, delete = {text = "\239\131\154"}, topdelete = {text = "\239\131\154"}, changedelete = {text = "\226\150\142"}, untracked = {text = "\226\150\142"}}, numhl = true, current_line_blame = true, current_line_blame_opts = {virt_text = true, virt_text_pos = "eol", delay = 500, virt_text_priority = 100, ignore_whitespace = false}, on_attach = _3_}
if is_in_arcadia() then
  return {dir = "~/arcadia/contrib/tier1/gitsigns.arc.nvim", dev = true, opts = gitsigns_opts}
else
  return {"lewis6991/gitsigns.nvim", opts = gitsigns_opts}
end
