local function bootstrap(url)
	local name = url:gsub(".*/", "")
	local path

	path = vim.fn.stdpath("data") .. "/lazy/" .. name
	vim.opt.rtp:prepend(path)

	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")

		vim.fn.system({ "git", "clone", url, path })

		vim.cmd("redraw")
		print(name .. ": finished installing")
	end
end


bootstrap("https://github.com/udayvir-singh/tangerine.nvim")
bootstrap("https://github.com/udayvir-singh/hibiscus.nvim")

require("tangerine").setup({
	compiler = {
		float = true, -- show output in floating window
		clean = true, -- delete stale lua files
		force = false, -- disable diffing (not recommended)
		verbose = false, -- disable messages showing compiled files

		globals = vim.tbl_keys(_G), -- list of alowed globals in fennel code		verbose = false,
		-- compile every time changes are made to fennel files or on entering vim
		hooks = { "onsave", "oninit" },
	},
	eval = {
		float = true,
		diagnostic = {
			virtual = true,
			timeout = 10,
		},
	},
	highlight = {
		float = "Normal",
		success = "String",
		errors = "DiagnosticError",
	},
})
