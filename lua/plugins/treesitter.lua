-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_(_, opts)
  return require("nvim-treesitter.configs").setup(opts)
end
local function _2_(plugin)
  require("lazy.core.loader").add_to_rtp(plugin)
  return require("nvim-treesitter.query_predicates")
end
return {{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", cmd = {"TSUpdateSync", "TSUpdate", "TSInstall"}, dependencies = {"pungy/shik-treesitter"}, pin = true, config = _1_, init = _2_, opts = {ensure_installed = {"html", "javascript", "jsdoc", "tsx", "typescript", "css", "astro", "http", "scss", "svelte", "toml", "json", "jsonc", "xml", "yaml", "markdown", "markdown_inline", "latex", "vimdoc", "luadoc", "bash", "lua", "python", "java", "commonlisp", "c", "cmake", "make", "cpp", "go", "rust", "sql", "fennel", "asm", "haskell", "wgsl", "diff", "luap", "printf", "query", "regex", "vim", "shik", "gitignore"}, highlight = {enable = true, additional_vim_regex_highlighting = {"markdown"}}, indent = {enable = true}}, opts_extend = {"ensure_installed"}, lazy = false, version = false}}
