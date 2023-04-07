-- see `:help vim.keymap.set()`
vim.keymap.set({"n", "v"}, "<Space>","<Nop>",{silent = true})

-- Remap for dealing with word wrap
vim.keymap.set("n","k","v:count == 0 ? 'gk' : 'k'", {expr = true, silent = true})
vim.keymap.set("n","j","v:count == 0 ? 'gj' : 'j'", {expr = true, silent = true})

-- Vim explorer
vim.keymap.set("n", "<Leader>.", "<cmd>Ex<CR>")

-- Telescope shortcuts
vim.keymap.set("n", "<Leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>")
vim.keymap.set("n", "<Leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set("n", "<Leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>")
vim.keymap.set("n", "<Leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>")

-- Enable moving code lines up and down
vim.keymap.set("n", "<A-j>","<cmd>m .+1<CR>==")
vim.keymap.set("n", "<A-k>","<cmd>m .-2<CR>==")
vim.keymap.set("i", "<A-j>","<Esc><cmd>m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>","<Esc><cmd>m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>","<cmd>m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>","<cmd>m '<-2<CR>gv=gv")

-- Center buffer when jumping around buffer
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Single delete char without copying into register
vim.keymap.set("n", "x", '"_x')

-- Switch buffers with H and L
vim.keymap.set("n", "H", "<cmd>bp<CR>")
vim.keymap.set("n", "L", "<cmd>bn<CR>")
