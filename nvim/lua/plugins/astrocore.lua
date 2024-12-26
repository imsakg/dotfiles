-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        -- signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        smartcase = true, -- sets vim.opt.smartcase
        ignorecase = true, -- sets vim.opt.ignorecase
        modifiable = true,
        autoread = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        cmp_enabled = true, -- enable completion at start
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_enabled = true, -- enable diagnostics at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        status_diagnostics_enabled = true, -- enable diagnostics in statusline
        inlay_hints_enabled = true, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
        lsp_handlers_enabled = true, -- enable or disable default vim.lsp.handlers (hover and signature help)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
        -- mkdp_browser = "Vivaldi",
        silicon = {
          background = "#191a21",
          ["window-controls"] = false,
          -- background = "#161616",
          -- ["theme"] = "gruvbox-dark",
          -- ["pad-horiz"] = 10,
          -- ["pad-vert"] = 10,
          -- ["round-corner"] = true,
        }, -- configure Silicon
        -- silicon = {
        --   background = "#d5cac2",
        --   ["window-controls"] = false,
        --   ["round-corner"] = true,
        --   ["theme"] = "gruvbox-dark",
        --   ["pad-horiz"] = 10,
        --   ["pad-vert"] = 10,
        -- }, -- configure Silicon
        -- noswapfile = true, -- disable swap files
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map
        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- Open telescope buffers
        ["<Leader><Tab>"] = {
          function()
            if #vim.t.bufs > 1 then
              require("telescope.builtin").buffers { sort_mru = true, ignore_current_buffer = true }
            else
              -- notify
            end
          end,
          desc = "Buffers",
        },
        -- Next buffer
        ["<Tab>"] = {
          function() require("astrocore.buffer").nav(vim.v.count1) end,
          desc = "Next buffer",
        },
        -- Previous buffer
        ["<S-Tab>"] = {
          function() require("astrocore.buffer").nav(-vim.v.count1) end,
          desc = "Previous buffer",
        },

        ["<Leader>:"] = { "<cmd>FineCmdline<cr>", desc = "FineCmdline" },

        -- Disable for vim-visual-multi
        ["C-up"] = { "<nop>", desc = "Disable" },
        ["C-down"] = { "<nop>", desc = "Disable" },
        ["C-left"] = { "<nop>", desc = "Disable" },
        ["C-right"] = { "<nop>", desc = "Disable" },

        -- Navigation
        ["<C-S-h>"] = { "<Cmd>vertical resize -2<CR>", desc = "Resize split left" },
        ["<C-S-k>"] = { "<Cmd>resize -2<CR>", desc = "Resize split up" },
        ["<C-S-j>"] = { "<Cmd>resize +2<CR>", desc = "Resize split down" },
        ["<C-S-l>"] = { "<Cmd>vertical resize +2<CR>", desc = "Resize split right" },

        ["<Leader><Leader>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" },

        ["<Leader>E"] = { desc = "Executor" },
        ["<Leader>Ee"] = { "<cmd>ExecutorRun<cr>", desc = "Executor Exec!" },
        ["<Leader>Et"] = { "<cmd>ExecutorToggleDetail<cr>", desc = "Executor Toggle Detail!" },
        ["<Leader>Eh"] = { "<cmd>ExecutorHistory<cr>", desc = "Executor Exec!" },
        ["<Leader>Es"] = { "<cmd>ExecutorRun<cr>", desc = "Executor Exec!" },

        ["<Leader>fu"] = { ":UndotreeToggle<cr>", desc = "Toggle undo history" },
        ["<Leader>fs"] = { function() require("resession").load "Last Session" end, desc = "Load last session" },

        ["<Leader>gg"] = { ":Git<cr>", desc = "Open Git" },

        ["<Leader>bz"] = { "<cmd>Screenkey toggle<cr>", desc = "Toggle Keys" },

        ["<Leader>fyc"] = { function() require("utils.fs").rel_path() end, desc = "Copy current file relative path" },
        ["<Leader>fya"] = { function() require("utils.fs").abs_path() end, desc = "Copy current file absolute path" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },

        ["tt"] = {
          function() require("toggleterm").toggle() end,
          desc = "Toggle Term",
        },
        ["<Leader>;"] = { ":2ToggleTerm size=30 direction=horizontal<cr>", desc = "Open terminal with tab" },
        -- ["<Leader>:"] = { ":2ToggleTerm size=60 direction=vertical<cr>", desc = "Open terminal with tab" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

        ["<leader>r"] = { name = " Rust Tools" },
        ["<leader>ra"] = { function() vim.cmd.RustLsp "codeAction" end, desc = "Rust Code Action" },
        ["<leader>rm"] = { function() vim.cmd.RustLsp "expandMacro" end, desc = "Expand Macro" },
        ["<leader>rC"] = { function() vim.cmd.RustLsp "openCargo" end, desc = "Open Cargo.toml" },
        ["<leader>rD"] = { function() vim.cmd.RustLsp "openDocs" end, desc = "Open Docs" },
        ["<leader>rp"] = { function() vim.cmd.RustLsp "parentModule" end, desc = "Parent Module" },
        ["<leader>rr"] = { function() vim.cmd.RustLsp "runnables" end, desc = "Rust Runnables" },
        ["<leader>rd"] = { function() vim.cmd.RustLsp "debuggables" end, desc = "Rust Debuggables" },
        ["<leader>rt"] = { function() vim.cmd.RustLsp "testables" end, desc = "Rust Testables" },
        ["<leader>rf"] = { function() vim.cmd.RustLsp "workspaceSymbol" end, desc = "Find Symbol" },
        ["<leader>rj"] = { function() vim.cmd.RustLsp "joinLines" end, desc = "Join Lines" },
        ["<leader>re"] = { function() vim.cmd.RustLsp "explainError" end, desc = "Explain Error" },
        -- Crates
        ["<leader>rc"] = { name = "Crates" },
        ["<leader>rcr"] = { function() require("crates").reload() end, desc = "Reload Crates" },
        ["<leader>rcf"] = { function() require("crates").show_features_popup() end, desc = "Show Features" },
        ["<leader>rcv"] = { function() require("crates").show_versions_popup() end, desc = "Show Versions" },
        ["<leader>rcd"] = { function() require("crates").show_dependencies_popup() end, desc = "Show Dependencies" },
        ["<leader>rcu"] = { function() require("crates").update() end, desc = "Update Crate" },
        ["<leader>rca"] = { function() require("crates").update_all_crates() end, desc = "Update All Crates" },
        ["<leader>rcU"] = { function() require("crates").upgrade_crate() end, desc = "Upgrade Crate" },
        ["<leader>rcA"] = { function() require("crates").upgrade_all_crates() end, desc = "Upgrade All Crates" },
        ["<leader>rcH"] = { function() require("crates").open_homepage() end, desc = "Open Homepage" },
        ["<leader>rcR"] = { function() require("crates").open_repository() end, desc = "Open Repository" },
        ["<leader>rcD"] = { function() require("crates").open_documentation() end, desc = "Open Documentation" },
        ["<leader>rcC"] = { function() require("crates").open_crates_io() end, desc = "Open crates.io" },

        -- Trouble
        ["<leader>x"] = { name = "Trouble" },
        ["<leader>xx"] = { "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble" },
        ["<leader>xd"] = {
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Trouble Document",
        },
        ["<leader>xl"] = { "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Location List" },
        ["<leader>xq"] = { "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix" },
        ["<leader>xr"] = {
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "Trouble LSP References",
        },
        -- Todo
        ["<leader>T"] = { name = "TODOs" },
        ["<leader>Tt"] = { "<cmd>TodoTelescope<cr>", desc = "Open TODOs in Telescope" },
        ["<leader>Tq"] = { "<cmd>TodoQuickFix<cr>", desc = "Open TODOs in QuickFix" },
        ["<leader>Tx"] = { "<cmd>TodoTrouble<cr>", desc = "Open TODOs in Trouble" },
        -- Telescope
        ["gr"] = { "<cmd>Telescope lsp_references<cr>", desc = "Go to References" },
        ["gs"] = { "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        ["<C-M-h>"] = { "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Call Hierarchy" },
      },
      t = {
        -- setting a mapping to false will disable it
        ["<esc>"] = false,
        ["tt"] = {
          function() require("toggleterm").toggle() end,
          desc = "Toggle Term",
        },
      },
      i = {
        ["<C-q>"] = { "<esc>:qa!<cr>", desc = "Exit" },
      },
      v = {
        -- Enter key
        ["<CR>"] = { "y/<C-R>*<CR>", desc = "Search Selection" },
        ["<Leader>p"] = { '"0p', desc = "Paste without replacing the buffer" },
        ["<C-r>"] = { '"hy:%s/<C-r>h//gc<left><left><left>', desc = "Replace" },
        -- ["<Leader>S"] = { ":'<,'>Silicon<cr>", desc = "Save image" },
      },
    },
  },
}
