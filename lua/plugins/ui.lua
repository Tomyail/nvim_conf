return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
  /^--^\     /^--^\     /^--^\
  \____/     \____/     \____/
/      \   /      \   /      \
|        | |        | |        |
\__  __/   \__  __/   \__  __/
|^|^|^|^|^|^|^|^|^|^|^|^\ \^|^|^|^/ /^|^|^|^|^\ \^|^|^|^|^|^|^|^|^|^|^|^|
| | | | | | | | | | | | |\ \| | |/ /| | | | | | \ \ | | | | | | | | | | |
| | | | | | | | | | | | / / | | |\ \| | | | | |/ /| | | | | | | | | | | |
| | | | | | | | | | | | \/| | | | \/| | | | | |\/ | | | | | | | | | | | |
#########################################################################
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        },
      },
      image = {},
      terminal = {
        enabled = true,
        win = {
          style = "toggleterm",
          position = "bottom",
          height = 0.4,
        },
      },
      lazygit = {
        win = {
          position = "float",
          backdrop = 60,
          height = 0.9,
          width = 0.9,
        },
      },
    },
    keys = {
      { "<leader>t", desc = "+Terminal" },
      { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
      { "<leader>t1", function() Snacks.terminal.toggle(nil, { win = { style = "toggleterm" } }) end, desc = "Terminal 1" },
      { "<leader>t2", function() Snacks.terminal.toggle(nil, { win = { style = "toggleterm" } }) end, desc = "Terminal 2" },
      { "<leader>t3", function() Snacks.terminal.toggle(nil, { win = { style = "toggleterm" } }) end, desc = "Terminal 3" },
      { "<leader>t4", function() Snacks.terminal.toggle(nil, { win = { style = "toggleterm" } }) end, desc = "Terminal 4" },
      { "<leader>tf", function() Snacks.terminal.toggle(nil, { win = { position = "float" } }) end, desc = "Float Terminal" },
      { "<leader>th", function() Snacks.terminal.toggle(nil, { win = { position = "bottom" } }) end, desc = "Horizontal Terminal" },
      { "<leader>tv", function() Snacks.terminal.toggle(nil, { win = { position = "right" } }) end, desc = "Vertical Terminal" },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        show_prompt = false,
        hint = "floating-big-letter",
        filter_rules = {

          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "NvimTree", "neo-tree", "notify" },

            -- if the file type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.right = opts.options.right or {}
      -- Use ~35% of the editor width so claude.nvim can render without wrapping
      opts.options.right.size = function()
        return math.floor(vim.o.columns * 0.3)
      end
      -- Set Neo-tree (left sidebar) default width
      opts.options.left = opts.options.left or {}
      opts.options.left.size = 40
    end,
  },
}
