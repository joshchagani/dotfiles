-- see `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Enable moving code lines up and down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==")
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv")

-- Center buffer when jumping around buffer
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Single delete char without copying into register
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- Switch buffers with H and L
vim.keymap.set("n", "H", "<cmd>bp<CR>")
vim.keymap.set("n", "L", "<cmd>bn<CR>")
