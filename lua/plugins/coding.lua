return {
  {
    "hrsh7th/nvim-cmp",
    config = function(_, opts)
      local cmp = require("cmp")
      local merged_opts = vim.tbl_deep_extend("force", {
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-x>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<ESC>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping({
            -- 在插入模式, 如果当前没有选择, 按下回车后是回车,如果当前有选择, 按下回车后是确认选择
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            -- 在选择模式, 按下回车后是确认选择
            s = cmp.mapping.confirm({ select = true }),
            -- 在命令模式, 按下回车后是确认选择, 并且会替换
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        }),
      }, opts)
      cmp.setup(merged_opts)
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    lazy = false,
    config = function()
      require("CopilotChat").setup({
        model = "gpt-4",
        --[[ model = 'gpt-3.5-turbo', ]]
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN 将上述代码的解释写为文本段落",
          },
        },
      })
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
    keys = {
      { "<leader>a", "Ask" },
      {
        "<leader>aa",
        function()
          local chat = require("CopilotChat")
          chat.toggle({
            selection = require("CopilotChat.select").buffer,
          })
        end,
        desc = "Chat",
      },
      {
        "<leader>ag",
        "<cmd>CopilotChatCommitStaged(English)<CR>",
        desc = "CopilotChatCommitStaged(English)",
      },

      {
        "<leader>aG",
        function()
          local chat = require("CopilotChat")
          local select = require("CopilotChat.select")
          chat.ask(
            "使用 commitizen convention 编写更改的提交标题。确保标题最多包含 50 个字符。 使用 gitcommit 语言将整个消息包装在代码块中,并用中文返回",
            {
              selection = function(source)
                return select.gitdiff(source, true)
              end,
            }
          )
        end,
        desc = "CopilotChatCommitStaged(中文)",
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "show help",
      },
    },
  },
}