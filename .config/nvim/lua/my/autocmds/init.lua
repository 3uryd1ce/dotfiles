-- luacheck: globals vim

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "No automatic commenting on newlines.",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = {
		os.getenv("HOME") .. "/.Xresources",
		os.getenv("HOME") .. "/.Xdefaults",
	},
	callback = function()
		if os.getenv("DISPLAY") then
			local filename = vim.fn.expand("%:p")
			os.execute("xrdb " .. filename)
		end
	end,
	desc = "Reload Xresources and Xdefaults with xrdb(1)",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.env.XDG_CONFIG_HOME .. "/sxhkd/sxhkdrc",
	callback = function()
		if os.getenv("DISPLAY") then
			os.execute("pkill -USR1 sxhkd")
		end
	end,
	desc = "Reload sxhkd(1) keybindings",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.filetype == "help" then
			require("zen-mode").toggle({
				on_close = function()
					vim.cmd("q")
				end,
			})
		end
	end,
	desc = "ZenMode is enabled for help files.",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"perl",
		"nroff",
		"html",
	},
	callback = function()
		-- Validate if current buffer is empty
		if vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_get_current_line() == "" then
			local skeleton_file = os.getenv("HOME") .. "/.local/share/nvim/skel/" .. vim.bo.filetype
			local lines = vim.fn.readfile(skeleton_file)
			vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
		end
	end,
	desc = "Load filetype-specific skeleton for new files",
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = {
		"*.[0-9]",
		"*.3p",
	},
	callback = function()
		vim.opt.filetype = "nroff"
	end,
	desc = 'Set "nroff" filetype for man pages with file names that end in 0-9 or 3p',
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*sxhkdrc",
	callback = function()
		vim.opt.filetype = "sxhkdrc"
	end,
	desc = "Set sxhkdrc to the sxhkdrc file type so it has syntax highlighting",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "/tmp/sh*",
	callback = function()
		vim.opt.filetype = "sh"
	end,
	desc = "Set command-line editing to sh filetype so it has syntax highlighting",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = {
		"/usr/ports/*",
		"/usr/src/*",
		"/usr/www/*",
		"/usr/xenocara/*",
	},
	callback = function()
		vim.opt.shiftwidth = 8
		vim.opt.tabstop = 8
		vim.opt.expandtab = false
	end,
	desc = "OpenBSD developers use 8 column tabs",
})
