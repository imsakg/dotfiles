---@type LazySpec
return {

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      table.insert(opts.section.buttons.val, opts.button("ng", "📝 Open Global Note", ":GlobalNote<CR>"))
      table.insert(
        opts.section.buttons.val,
        opts.button(
          "no",
          "🔮 Open Obsidian Vault",
          ":cd /Users/msa/Library/Mobile Documents/iCloud~md~obsidian/Documents/msa-verse<CR>"
        )
      )
      table.insert(opts.section.buttons.val, opts.button("h", "👋 Say Hi", ':echo "Hello World!"<CR>'))
      table.insert(opts.section.buttons.val, opts.button("cz", "🔧 Configure ZSH", ":e ~/.zshrc<CR>"))
      table.insert(
        opts.section.buttons.val,
        opts.button("cw", "🔧 Configure Wezterm", ":e ~/.config/wezterm/wezterm.lua<CR>")
      )
      table.insert(opts.section.buttons.val, opts.button("r", "🔃 Relaod Config", ":AstroReload<CR>"))
      opts.section.header.val = {
        "• ▌ ▄ ·. .▄▄ ·  ▄▄▄· ",
        "·██ ▐███▪▐█ ▀. ▐█ ▀█ ",
        "▐█ ▌▐▌▐█·▄▀▀▀█▄▄█▀▀█ ",
        "██ ██▌▐█▌▐█▄▪▐█▐█ ▪▐▌",
        "▀▀  █▪▀▀▀ ▀▀▀▀  ▀  ▀ ",
      }
      return opts
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
          Rule(" ", " "):with_pair(function(options)
            local pair = options.line:sub(options.col - 1, options.col)
            return vim.tbl_contains({ "()", "[]", "{}" }, pair)
          end),
          Rule("( ", " )")
            :with_pair(function() return false end)
            :with_move(function(options) return options.prev_char:match ".%)" ~= nil end)
            :use_key ")",
          Rule("{ ", " }")
            :with_pair(function() return false end)
            :with_move(function(options) return options.prev_char:match ".%}" ~= nil end)
            :use_key "}",
          Rule("[ ", " ]")
            :with_pair(function() return false end)
            :with_move(function(options) return options.prev_char:match ".%]" ~= nil end)
            :use_key "]",
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
