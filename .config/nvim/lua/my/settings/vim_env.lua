-- luacheck: globals vim

vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or os.getenv("HOME") .. "/.config"
vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or os.getenv("HOME") .. "/.local/share"
vim.env.XDG_STATE_HOME = vim.env.XDG_STATE_HOME or os.getenv("HOME") .. "/.local/state"
