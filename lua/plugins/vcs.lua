-- [nfnl] fnl/plugins/vcs.fnl
local _local_1_ = require("utils.yndx")
local is_in_arcadia = _local_1_["is-in-arcadia"]
local gitsigns_opts
local function _2_(bufnr)
  local gs = require("gitsigns")
  local function _3_()
    return gs.nav_hunk("next")
  end
  vim.keymap.set({"n"}, "]h", _3_, {desc = "Next hunk", silent = true, buffer = true})
  local function _4_()
    return gs.nav_hunk("prev")
  end
  vim.keymap.set({"n"}, "[h", _4_, {desc = "Prev hunk", silent = true, buffer = true})
  vim.keymap.set({"n", "v"}, "<leader>vs", "<cmd>:Gitsigns stage_hunk<cr>", {desc = "Stage Hunk", silent = true, buffer = true})
  vim.keymap.set({"n", "v"}, "<leader>vr", "<cmd>:Gitsigns reset_hunk<cr>", {desc = "Reset Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vS", gs.stage_buffer, {desc = "Stage Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vu", gs.undo_stage_hunk, {desc = "Undo Stage Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vR", gs.reset_buffer, {desc = "Reset Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vp", gs.preview_hunk_inline, {desc = "Preview Hunk Inline", silent = true, buffer = true})
  local function _5_()
    return gs.blame_line({full = true})
  end
  vim.keymap.set({"n"}, "<leader>vb", _5_, {desc = "Blame Line", silent = true, buffer = true})
  local function _6_()
    return gs.blame()
  end
  vim.keymap.set({"n"}, "<leader>vB", _6_, {desc = "Blame Buffer", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vd", gs.diffthis, {desc = "Diff This", silent = true, buffer = true})
  local function _7_()
    return gs.diffthis("~")
  end
  vim.keymap.set({"n"}, "<leader>vD", _7_, {desc = "Diff This ~", silent = true, buffer = true})
  vim.keymap.set({"o", "x"}, "ih", "<cmd>:<C-U>Gitsigns select_hunk<cr>", {desc = "GitSigns Select Hunk", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vms", "<cmd>terminal git add . && git commit -m $(timestamp) && git push<cr>", {desc = "Save changes and push", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmP", "<cmd>terminal git push<cr>", {desc = "Push", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmp", "<cmd>terminal git pull<cr>", {desc = "Pull", silent = true, buffer = true})
  vim.keymap.set({"n"}, "<leader>vmh", "<cmd>terminal git stash<cr>", {desc = "Stash changes (hide)", silent = true, buffer = true})
  return vim.keymap.set({"n"}, "<leader>vmu", "<cmd>terminal git stash pop<cr>", {desc = "Unstash changes (unhide)", silent = true, buffer = true})
end
gitsigns_opts = {signs = {add = {text = "\226\150\142"}, change = {text = "\226\150\142"}, delete = {text = "\239\131\154"}, topdelete = {text = "\239\131\154"}, changedelete = {text = "\226\150\142"}, untracked = {text = "\226\150\142"}}, numhl = true, current_line_blame = true, current_line_blame_opts = {virt_text = true, virt_text_pos = "eol", delay = 500, virt_text_priority = 100, ignore_whitespace = false}, on_attach = _2_}
local function _10_(...)
  if is_in_arcadia() then
    local function _8_()
      local function fzf_arcadia()
        return require("fzf-lua").files({cmd = "arc status -s | awk '{print substr($0, index($0,$2))}'", prompt = "ArcFiles\226\157\175 ", hidden = false})
      end
      return vim.keymap.set({"n"}, "<leader>fv", fzf_arcadia, {desc = "Find changed files"})
    end
    return {dir = "~/arcadia/contrib/tier1/gitsigns.arc.nvim", dev = true, init = _8_, opts = gitsigns_opts}
  else
    local function _9_()
      return vim.keymap.set({"n"}, "<leader>fv", "<cmd>FzfLua git_status<cr>", {desc = "Find changed files"})
    end
    return {"lewis6991/gitsigns.nvim", init = _9_, opts = gitsigns_opts}
  end
end
return {_10_(...)}
