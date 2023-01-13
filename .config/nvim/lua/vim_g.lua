-- luacheck: globals vim
-- Global editor variables.

vim.g.mapleader = ','

-- https://github.com/jamessan/vim-gnupg/issues/119
-- https://github.com/jamessan/vim-gnupg/issues/32
vim.g.GPGUsePipes = 1
vim.g.GPGDefaultRecipients = "90965AE120F8E848979DEA4853670DEBCF375780"

-- VimTeX should use zathura as the viewer
vim.g.vimtex_view_method = 'zathura'

-- allow Markdown folds
vim.g.markdown_folding = 1

-- run linters/syntax checks on open, but not on close
vim.g.syntastic_check_on_open = 1
vim.g.syntastic_check_on_wg = 0

vim.g.syntastic_lua_checkers = { 'luacheck', 'luac53' }
vim.g.syntastic_markdown_checkers = { 'proselint' }
vim.g.syntastic_tex_checkers = { 'chktex', 'lacheck', 'proselint' }