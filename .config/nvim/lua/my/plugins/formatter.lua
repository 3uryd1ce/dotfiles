-- luacheck: globals vim

return {
	"mhartington/formatter.nvim",
	lazy = true,
	ft = {
		"css",
		"go",
		"html",
		"json",
		"lua",
		"markdown",
		"perl",
		"python",
		"sh",
		"yaml",
	},
	config = function()
		require("formatter").setup({
			filetype = {
				css = {
					require("formatter.filetypes.css").prettier,
				},
				go = {
					require("formatter.filetypes.go").gofumpt,
				},
				html = {
					require("formatter.filetypes.html").prettier,
				},
				json = {
					require("formatter.filetypes.json").prettier,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				markdown = {
					require("formatter.filetypes.markdown").prettier,
				},
				perl = {
					function()
						return {
							exe = "perltidy",
							args = {
								"--quiet",
							},
							stdin = true,
						}
					end,
				},
				python = {
					require("formatter.filetypes.python").black,
				},
				sh = {
					function()
						local shiftwidth = vim.opt.shiftwidth:get()
						local expandtab = vim.opt.expandtab:get()

						if not expandtab then
							shiftwidth = 0
						end

						return {
							exe = "shfmt",
							args = {
								"--simplify",
								"--case-indent",
								"--binary-next-line",
								"--space-redirects",
								"--indent",
								shiftwidth,
							},
							stdin = true,
						}
					end,
				},
				yaml = {
					require("formatter.filetypes.yaml").prettier,
				},
			},
		})
	end,
}
