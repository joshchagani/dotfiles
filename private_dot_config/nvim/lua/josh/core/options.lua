local opt = vim.opt -- for conciseness
local o = vim.o

-- set leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
opt.nu = true

-- tabs & indentation
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.softtabstop = 4
opt.shiftwidth = 4

-- line wrapping
opt.wrap = false

-- spelling
opt.spell = true
opt.spelllang = "en_us"

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- turn on termguicolors for colorscheme to work properly
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

o.mouse = "a"
o.breakindent = true
o.updatetime = 250
o.completeopt = "menu,menuone,noselect"
o.undofile = true
