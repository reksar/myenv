local vimconfig = vim.fn.stdpath("config")
local is_win = vim.fn.has("win32") == 1
local vimrc = is_win and vimconfig .. "/.vimrc" or "~/.vimrc"
vim.cmd("source " .. vimrc)
vim.cmd("source " .. vimconfig .. "/plugs.vim")
