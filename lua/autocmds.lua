-- [nfnl] fnl/autocmds.fnl
local _local_1_ = require("utils.augroup")
local augroup = _local_1_.augroup
local au = vim.api.nvim_create_autocmd
local function _2_()
  return vim.hl.on_yank()
end
au("TextYankPost", {group = augroup("highlight-yank"), callback = _2_})
local function on_lsp_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  local function _3_()
    return vim.lsp.buf.hover({border = "rounded"})
  end
  vim.keymap.set("n", "K", _3_, {buffer = bufnr, desc = "Hover docs", silent = true})
  local function _4_()
    return require("conform").format({bufnr = bufnr, lsp_fallback = true})
  end
  vim.keymap.set("n", "<leader>cf", _4_, {buffer = bufnr, desc = "Format buffer", silent = true})
  vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, {buffer = bufnr, desc = "Run code lens", silent = true})
  local function _5_()
    local filter = {bufnr = bufnr}
    local enabled_3f = vim.lsp.inlay_hint.is_enabled(filter)
    return vim.lsp.inlay_hint.enable(not enabled_3f, filter)
  end
  vim.keymap.set("n", "<leader>th", _5_, {buffer = bufnr, desc = "Toggle inlay hints", silent = true})
  local function _6_()
    local current
    local _8_
    do
      local t_7_ = vim.diagnostic.config()
      if (nil ~= t_7_) then
        t_7_ = t_7_.virtual_lines
      else
      end
      _8_ = t_7_
    end
    current = (_8_ or false)
    return vim.diagnostic.config({virtual_lines = not current})
  end
  vim.keymap.set("n", "<leader>tl", _6_, {buffer = bufnr, desc = "Toggle virtual_lines diagnostics", silent = true})
  if (client and client:supports_method("textDocument/foldingRange")) then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
  else
  end
  if (client and client:supports_method("textDocument/codeLens")) then
    return vim.lsp.codelens.enable(true, {bufnr = bufnr})
  else
    return nil
  end
end
au("LspAttach", {group = augroup("lsp-attach"), callback = on_lsp_attach})
local function _12_()
  local ft = vim.bo.filetype
  local line = vim.fn.line("'\"")
  local last = vim.fn.line("$")
  if ((line > 1) and (line <= last) and not vim.tbl_contains({"gitcommit", "gitrebase"}, ft)) then
    return vim.cmd("normal! g`\"")
  else
    return nil
  end
end
au("BufReadPost", {group = augroup("restore-cursor"), callback = _12_})
local function _14_()
  return vim.opt_local.iskeyword:append({"-", "?", "!"})
end
return au("FileType", {group = augroup("lisp-ft"), pattern = {"fennel", "lisp", "clojure", "scheme", "commonlisp"}, callback = _14_})
