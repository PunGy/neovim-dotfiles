-- [nfnl] fnl/plugins/vcs.fnl
local _local_1_ = require("utils.exec")
local cmd = _local_1_.cmd
local term_cmd = _local_1_["term-cmd"]
local _local_2_ = require("utils.yndx")
local is_in_arcadia = _local_2_["is-in-arcadia"]
local gitsigns_opts
local function _3_(bufnr)
  local gs = require("gitsigns")
  local function _4_()
    return gs.nav_hunk("next")
  end
  vim.keymap.set({"n"}, "]h", _4_, {desc = "Next hunk", silent = true, buffer = true})
  local function _5_()
    return gs.nav_hunk("prev")
  end
  vim.keymap.set({"n"}, "[h", _5_, {desc = "Prev hunk", silent = true, buffer = true})
  vim.keymap.set({"n", "v"}, "<leader>vs", cmd(":Gitsigns stage_hunk"), {desc = "Stage Hunk", silent = true, buffer = true})
  vim.keymap.set({"n", "v"}, "<leader>vr", cmd(":Gitsigns reset_hunk"), {desc = "Reset Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vS", gs.stage_buffer, {desc = "Stage Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vu", gs.undo_stage_hunk, {desc = "Undo Stage Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vR", gs.reset_buffer, {desc = "Reset Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vp", gs.preview_hunk_inline, {desc = "Preview Hunk Inline", silent = true, buffer = true})
  local function _6_()
    return gs.blame_line({full = true})
  end
  vim.keymap.set({"n"}, "<leader>vb", _6_, {desc = "Blame Line", silent = true, buffer = true})
  local function _7_()
    return gs.blame()
  end
  vim.keymap.set({"n"}, "<leader>vB", _7_, {desc = "Blame Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vd", gs.diffthis, {desc = "Diff This", silent = true, buffer = true})
  local function _8_()
    return gs.diffthis("~")
  end
  vim.keymap.set({"n"}, "<leader>vD", _8_, {desc = "Diff This ~", silent = true, buffer = true})
  vim.keymap.set({"o", "x"}, "ih", cmd(":<C-U>Gitsigns select_hunk"), {desc = "GitSigns Select Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vms", term_cmd("git add . && git commit -m $(timestamp) && git push"), {desc = "Save changes and push", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmP", term_cmd("git push"), {desc = "Push", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmp", term_cmd("git pull"), {desc = "Pull", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmh", term_cmd("git stash"), {desc = "Stash changes (hide)", silent = true, buffer = true})
  return vim.keymap.set({"n"}, "<leader>vmu", term_cmd("git stash pop"), {desc = "Unstash changes (unhide)", silent = true, buffer = true})
end
gitsigns_opts = {signs = {add = {text = "\226\150\142"}, change = {text = "\226\150\142"}, delete = {text = "\239\131\154"}, topdelete = {text = "\239\131\154"}, changedelete = {text = "\226\150\142"}, untracked = {text = "\226\150\142"}}, numhl = true, current_line_blame = true, current_line_blame_opts = {virt_text = true, virt_text_pos = "eol", delay = 500, virt_text_priority = 100, ignore_whitespace = false}, on_attach = _3_}
local function _9_(...)
  if is_in_arcadia() then
    return {dir = "~/arcadia/contrib/tier1/gitsigns.arc.nvim", dev = true, opts = gitsigns_opts}
  else
    return {"lewis6991/gitsigns.nvim", opts = gitsigns_opts}
  end
end
return {_9_(...)}
