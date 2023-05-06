vim.opt.runtimepath:append("/usr/share/nvim/site/pack/dist/start/nvim-treesitter/parser")
require'nvim-treesitter.configs'.setup {
	parser_install_dir = "/usr/share/nvim/site/pack/dist/start/nvim-treesitter/parser",
	highlight = {
		enable = true,
	},
	indent = {
		enable = true
	}
}
