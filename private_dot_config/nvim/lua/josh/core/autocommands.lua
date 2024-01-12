local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "man" },
	group = augroup,
	desc = "Use q to close the window",
	command = "nnoremap <buffer> q <cmd>quit<CR>",
})
