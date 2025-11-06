return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
      },
    },
  },
  {
    enabled = false,
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local node_path = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/18.19.0/bin/node"
      local copilot_node_command = "node"
      if vim.fn.filereadable(node_path) == 1 then
        copilot_node_command = node_path -- Node.js version must be > 18.x
      end
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          yaml = true,
        },
        copilot_node_command = copilot_node_command,
      })
    end,
  },
  -- { "nvim-mini/mini.pairs", enabled = false },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    opts = function()
      return {
        context = { "buffer" },
        window = {
          width = 0.3,
          -- layout = "float",
        },
        auto_insert_mode = true,
        insert_at_end = true,
      }
    end,
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
      focus_after_send = true,
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  }
}
