-- [nfnl] fnl/plugins/treesitter.fnl
local _local_1_ = require("utils.augroup")
local augroup = _local_1_.augroup
local au = vim.api.nvim_create_autocmd
local ensure_installed = {"html", "javascript", "jsdoc", "tsx", "typescript", "css", "astro", "http", "scss", "svelte", "toml", "json", "jsonc", "xml", "yaml", "markdown", "markdown_inline", "latex", "vimdoc", "luadoc", "bash", "lua", "python", "java", "commonlisp", "c", "cmake", "make", "cpp", "go", "rust", "sql", "fennel", "asm", "haskell", "wgsl", "diff", "luap", "printf", "query", "regex", "vim", "gitignore"}
local function _2_()
  do
    local ts = require("nvim-treesitter")
    ts.setup()
    ts.install(ensure_installed)
  end
  local function _3_(args)
    return pcall(vim.treesitter.start, args.buf)
  end
  return au("FileType", {group = augroup("treesitter-start"), callback = _3_})
end
return {{"nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", config = _2_, lazy = false}}
