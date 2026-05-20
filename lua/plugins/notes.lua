-- [nfnl] fnl/plugins/notes.fnl
local _local_1_ = require("utils.system")
local is_dir = _local_1_["is-dir"]
local function _2_()
  local function insert_timestamp()
    local timestamp = os.date("(%H:%M): ")
    return vim.api.nvim_put({timestamp}, "c", true, true)
  end
  local function make_list(type)
    local list_str = "- [ ] "
    if (type == "new-list") then
      local _let_3_ = vim.api.nvim_win_get_cursor(0)
      local current_line = _let_3_[1]
      vim.api.nvim_put({list_str}, "l", true, true)
      return vim.api.nvim_win_set_cursor(0, {(current_line + 1), #list_str})
    else
      return nil
    end
  end
  require("zk").setup({picker = "fzf_lua", lsp = {config = {cmd = {"zk", "lsp"}, name = "zk"}}})
  local function _5_()
    local title = vim.fn.input("Title: ")
    if (title ~= "") then
      return require("zk.commands").get("ZkNew")({title = title})
    else
      return nil
    end
  end
  vim.keymap.set({"n"}, "<A-n>", _5_, {})
  local function _7_()
    return require("zk.commands").get("ZkNotes")()
  end
  vim.keymap.set({"n"}, "<localleader>f", _7_, {desc = "Find note by name"})
  local function _8_()
    return require("zk.commands").get("ZkTags")()
  end
  vim.keymap.set({"n"}, "<localleader>t", _8_, {desc = "Notes by tag"})
  local function _9_()
    return require("zk.commands").get("ZkBacklinks")()
  end
  vim.keymap.set({"n"}, "<localleader>b", _9_, {desc = "Find links to this note"})
  local function _10_()
    return require("zk.commands").get("ZkLinks")()
  end
  vim.keymap.set({"n"}, "<localleader>l", _10_, {desc = "Show links in this note"})
  local function _11_()
    return require("zk.commands").get("ZkNew")({group = "daily", dir = "daily"})
  end
  vim.keymap.set({"n"}, "<localleader>d", _11_, {desc = "Open daily note"})
  vim.keymap.set({"n", "i"}, "<A-;>", insert_timestamp, {})
  local function _12_()
    return make_list("new-list")
  end
  return vim.keymap.set({"n", "i"}, "<A-o>", _12_, {})
end
return {{"zk-org/zk-nvim", lazy = not is_dir((vim.fn.getcwd() .. "/.zk")), config = _2_}}
