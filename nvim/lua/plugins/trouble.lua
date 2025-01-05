return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { Trouble = "󱍼" } } },
    { "nvim-tree/nvim-web-devicons" },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>x"
        if require("astrocore").is_available "todo-comments.nvim" then
          maps.n[prefix .. "t"] = { "<cmd>Trouble todo<cr>", desc = "Trouble Todo" }
          maps.n[prefix .. "T"] =
            { "<cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<cr>", desc = "Trouble Todo/Fix/Fixme" }
        end
      end,
    },
  },
  opts = function()
    local get_icon = require("astroui").get_icon
    local lspkind_avail, lspkind = pcall(require, "lspkind")
    return {
      keys = {
        ["<ESC>"] = "close",
        ["q"] = "close",
        ["<C-E>"] = "close",
      },
      icons = {
        indent = {
          fold_open = get_icon "FoldOpened",
          fold_closed = get_icon "FoldClosed",
        },
        folder_closed = get_icon "FolderClosed",
        folder_open = get_icon "FolderOpen",
        kinds = lspkind_avail and lspkind.symbol_map,
      },
    }
  end,
  specs = {
    { "lewis6991/gitsigns.nvim", optional = true, opts = { trouble = true } },
    {
      "folke/edgy.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.bottom then opts.bottom = {} end
        table.insert(opts.bottom, "Trouble")
      end,
    },
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { lsp_trouble = true } },
    },
  },
}
