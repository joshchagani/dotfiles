return {
	"gbprod/yanky.nvim",
	config = function()
		local yanky = require("yanky")
		yanky.setup({})
		vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
		vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

		local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

		vim.api.nvim_create_autocmd("TextYankPost", {
			group = augroup,
			desc = "Highlight on yank",
			callback = function()
				vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
			end,
		})
	end,
}
