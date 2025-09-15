return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "storm", transparent = false },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    optional = true,
    -- https://github.com/LazyVim/LazyVim/pull/6354#issuecomment-3203793593
    opts = function()
        local bufferline = require("catppuccin.groups.integrations.bufferline")
        bufferline.get = bufferline.get or bufferline.get_theme
        return {
          flavour = "frappe",
          transparent_background = false,
          integrations = {
            aerial = true,
            alpha = true,
            cmp = true,
            dashboard = true,
            flash = true,
            gitsigns = true,
            headlines = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            leap = true,
            lsp_trouble = true,
            mason = true,
            markdown = true,
            mini = true,
            native_lsp = {
              enabled = true,
              underlines = {
                errors = { "undercurl" },
                hints = { "undercurl" },
                warnings = { "undercurl" },
                information = { "undercurl" },
              },
            },
            navic = { enabled = true, custom_bg = "lualine" },
            neotest = true,
            neotree = true,
            noice = true,
            notify = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            which_key = true,
          },
        }
    end,
  },
}
