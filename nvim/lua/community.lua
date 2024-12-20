-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- Theming   ──────────────────────────────────────────────────────────────────────
  {
    -- further customize the options set by the community
    import = "astrocommunity.colorscheme.catppuccin",
    opts = {
      integrations = {
        sandwich = false,
        noice = true,
        mini = true,
        leap = true,
        markdown = true,
        neotest = true,
        cmp = true,
        overseer = true,
        lsp_trouble = true,
        ts_rainbow2 = true,
      },
    },
  },
  { import = "astrocommunity.colorscheme.nightfox", enabled = false },

  { import = "astrocommunity.completion.blink-cmp" },
  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-calc" },
  {
    -- further customize the options set by the community
    import = "astrocommunity.completion.copilot-lua-cmp",
    opts = {
      suggestion = {
        keymap = {
          accept = "<C-l>",
          accept_word = "<C-J>",
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
          dismiss = "<C/>",
        },
      },
    },
  },
  -- { "github/copilot.vim" },
  -- { import = "astrocommunity.editing-support.copilotchat-nvim" },

  -- Packs
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.mdx" },
  -- { import = "astrocommunity.pack.php" },
  -- { import = "astrocommunity.pack.proto" },
  -- { import = "astrocommunity.pack.ps1" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.svelte" },
  { import = "astrocommunity.pack.swift" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  -- { import = "astrocommunity.pack.vue" },
  -- { import = "astrocommunity.pack.wgsl" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.zig" },
  -- Markdown - Latex
  { import = "astrocommunity.markdown-and-latex.peek-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  -- Themes
  { import = "astrocommunity.colorscheme.nightfox-nvim", enabled = false },
  { import = "astrocommunity.colorscheme.kanagawa-nvim", enabled = true },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim", opts = {
    colorcolumn = 120,
  } },

  { import = "astrocommunity.search.nvim-spectre" },

  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.code-runner.executor-nvim" },

  { import = "astrocommunity.editing-support.suda-vim" },

  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.editing-support.comment-box-nvim" }, -- <Cmd> CBox: Creating Comment Boxes
  -- { import = "astrocommunity.editing-support.cutlass-nvim" }, -- Plugin that adds a 'cut' operation separate from 'delete'
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.vim-move" },
  -- { import = "astrocommunity.editing-support.nvim-treesitter-context" },

  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.colorscheme.vscode-nvim" },
  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.recipes.heirline-mode-text-statusline" },
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.note-taking.neorg" },
  { import = "astrocommunity.note-taking.global-note-nvim" },

  { "echasnovski/mini.nvim", version = "*" },
  { import = "astrocommunity.indent.mini-indentscope" },
  { import = "astrocommunity.motion.marks-nvim" },
  -- { import = "astrocommunity.workflow.precognition-nvim" },

  -- Personal Extensions
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  { "max397574/better-escape.nvim", enabled = false },
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
    "rebelot/kanagawa.nvim",
    config = function()
      local kanagawa = require "kanagawa"
      kanagawa.setup {
        transparent = true,
        theme = "wave",
      }
    end,
  },
  { "m-pilia/vim-pkgbuild", lazy = false },
  { "iamcco/markdown-preview.nvim", lazy = false },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup {
        default_mappings = false,
      }
    end,
    lazy = false,
  },
  { "folke/zen-mode.nvim", lazy = false },
  { "mbbill/undotree", lazy = false },
  { "tpope/vim-fugitive", lazy = false },
  { "Eandrju/cellular-automaton.nvim", lazy = false },
  { "segeljakt/vim-silicon", lazy = false },
  { "TheBlob42/houdini.nvim", lazy = false },
  { "mzlogin/vim-markdown-toc", lazy = false },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local gitlinker = require "gitlinker"
      gitlinker.setup()
    end,
    lazy = false,
  },
  {
    "henriklovhaug/Preview.nvim",
    cmd = { "Preview" },
    config = function() require("preview").setup() end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zjp-CN/nvim-cmp-lsp-rs",
        ---@type cmp_lsp_rs.Opts
        opts = {
          -- Filter out import items starting with one of these prefixes.
          -- A prefix can be crate name, module name or anything an import
          -- path starts with, no matter it's complete or incomplete.
          -- Only literals are recognized: no regex matching.
          unwanted_prefix = { "ratatui::crossterm::style::Stylize", "crossterm", "Styled" },
        },
      },
    },
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  "frazrepo/vim-rainbow",
  "PotatoesMaster/i3-vim-syntax",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "wakatime/vim-wakatime",
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
  },

  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@param opts AstroLSPOpts
    opts = {
      handlers = { rust_analyzer = false }, -- disable setup of `rust_analyzer`
      ---@diagnostic disable: missing-fields
      config = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-neorg/neorg",
    cmd = "Neorg", -- lazy load on command, allows you to autocomplete :Neorg regardless of whether it's loaded yet
    --  (you could also just remove both lazy loading things)
    priority = 30, -- treesitter is on default priority of 50, neorg should load after it.
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
        },
      }
    end,

    opts = {
      load = {
        ["core.journal"] = {
          config = {
            workspace = "notes",
            dir = "~/Documents/Notes/Journal",
          },
        },
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Documents/Notes",
            },
          },
        },
      },
    },
  },
}
