-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}

-- github/copilot.vim
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.cmd [[nnoremap <expr> <silent> 0 col('.') == match(getline('.'),'S')+1 ? '0' : '^']]
-- configure the litee.nvim library
require("litee.lib").setup {}
-- configure litee-calltree.nvim
require("litee.calltree").setup {}
