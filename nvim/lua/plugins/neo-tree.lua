-- theme colors
local colors = {
  dark = "#111317",
  light = "#777777",
  neutral = "#8094B4",
  backdrop = "#61afef",
}

local new_highlights = {
  -- indentline marker
  NeoTreeIndentMarker = { fg = colors.neutral },

  -- file tree window separator
  NeoTreeWinSeparator = { fg = colors.dark, bg = colors.dark },

  -- info messages
  NeoTreeMessage = { link = "NeoTreeDotfile" },

  -- normal mode appearance
  NeoTreeNormal = { bg = colors.dark },
  NeoTreeNormalNC = { link = "NeoTreeNormal" },

  -- dotfiles
  NeoTreeDotfile = { fg = colors.light },
  NeoTreeDotfiles = { link = "NeoTreeDotfile" },

  -- tabs
  NeoTreeTabActive = { fg = colors.dark, bg = colors.backdrop, bold = true },
  NeoTreeTabInactive = { fg = colors.light, bg = colors.dark },

  -- tab separators
  NeoTreeTabSeparatorActive = { fg = colors.backdrop, bg = colors.backdrop },
  NeoTreeTabSeparatorInactive = { link = "NeoTreeWinSeparator" },

  -- file operations prompt
  NeoTreeTitleBar = { link = "NeoTreeTabActive" },
  NeoTreeFloatNormal = { bg = colors.dark },
  NeoTreeFloatBorder = { fg = colors.backdrop, bg = colors.dark },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    if not opts.highlights then opts.highlights = {} end
    local astrodark = opts.highlights.astrodark
    if type(astrodark) == "function" then
      opts.highlights.astrodark = function(...) return require("astrocore").extend_tbl(astrodark(...), new_highlights) end
    else
      opts.highlights.astrodark = require("astrocore").extend_tbl(astrodark, new_highlights)
    end

    opts = {
      filesystem = {
        -- hijack_netrw_behavior = "disabled",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_pattern = {
            "**/.git",
            "**/.DS_Store",
            "**/node_modules",
            "**/target",
            "**/zig-cache",
            "**/zig-out",
          },
        },
        window = {
          mappings = {
            ["o"] = "open",
            ["h"] = function(state)
              local node = state.tree:get_node()
              if node.type == "directory" and node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
              end
            end,
            ["l"] = function(state)
              local node = state.tree:get_node()
              if node.type == "directory" then
                if not node:is_expanded() then
                  require("neo-tree.sources.filesystem").toggle_directory(state, node)
                elseif node:has_children() then
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            end,
          },
        },
      },
    }
    return opts
  end,
}
