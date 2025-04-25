-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.cmd [[nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'S')+1 ? '0' : '^']]
-- configure the litee.nvim library
require("litee.lib").setup {}
-- configure litee-calltree.nvim
require("litee.calltree").setup {}
