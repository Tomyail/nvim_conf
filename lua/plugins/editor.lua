return {
  -- override default plguns
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1365
      auto_clean_after_session_restore = true,
      filesystem = {
        follow_current_file = { enabled = false, leave_dirs_open = true },
      },
      window = {
        mappings = {
          ["o"] = "open",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local filename = node.name
            vim.fn.setreg("+", filename)
            vim.notify('Copied: ' .. filename)
          end,
        },
      },
    },
    keys = {
      { "<leader>e", desc = "+Neotree" },
      { "<leader>ee", "<cmd>Neotree filesystem toggle<cr>", desc = "Toggle" },
      {
        "<leader>ef",
        function()
          vim.api.nvim_command("Neotree filesystem reveal")
        end,
        desc = "Find",
      },
      { "<leader>d", desc = "+ search under cursor" },
      {
        "<leader>dF",
        function()
          local state = require("neo-tree.sources.manager").get_state("filesystem")
          local tree = state.tree
          if not tree then
            vim.notify("please open neotree first")
            return
          end
          local node = tree:get_node()
          local dir = node.type == "file" and node:get_parent_id() or node:get_id()

          local fzf = require('fzf-lua')
          fzf.live_grep({ cwd = dir })
        end,
        desc = "grep",
      },
      {
        "<leader>df",
        function()
          local state = require("neo-tree.sources.manager").get_state("filesystem")
          local tree = state.tree
          if not tree then
            vim.notify("please open neotree first")
            return
          end
          local node = tree:get_node()
          local dir = node.type == "file" and node:get_parent_id() or node:get_id()

          local fzf = require('fzf-lua')
          fzf.files({ cwd = dir })
        end,
        desc = "find",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- below are custom plugin
  {
    lazy = false,
    "tomyail/yasi.nvim",
    dependencies = {
      "uga-rosa/utf8.nvim",
    },
    opts = {
      lang = {
        cjk = {
          methods = {
            {
              os = "darwin",
              cmd = "im-select",
              input = "com.apple.inputmethod.SCIM.ITABC", -- I use [Rime](https://github.com/rime/squirrel)
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("yasi").setup(opts)
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
          local yasi = require("yasi")
          yasi.change_to_default()
        end,
      })
    end,
    dir = vim.fn.stdpath("config") .. "/yasi",
  },
  {
    "christoomey/vim-tmux-navigator",
    enabled = function()
      return vim.fn.getenv("TERM_PROGRAM") == "tmux"
    end,
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    enabled = function()
      return vim.fn.getenv("TERM_PROGRAM") == "WezTerm"
    end,
    keys = {
      {
        "<c-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
      },
      {
        "<c-j>",

        function()
          require("smart-splits").move_cursor_down()
        end,
      },
      {
        "<c-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
      },
      {
        "<c-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    keys = {
      { "<leader>o", desc = "+Obsidian" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "ObsidianToday" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "ObsidianNew" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "ObsidianBacklinks" },
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      templates = {
        subdir = "nvim_templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        -- folder = "journals/%Y/%m",
        folder = "journals",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y_%m_%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "日记.md",
      },
      image_name_func = function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end,
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "assets/imgs", -- This is the default
        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
          -- TODO: get image path relative to current note
          -- local current_note = client:current_note()
          -- if not current_note then
          --   return string.format("![%s](%s)", path.name, path)
          -- end
          --
          --
          -- local x = client:vault_root()
          -- local note_path = current_note.path
          -- local ok, relative_path = pcall(function()
          --   return path:relative_to(note_path)
          -- end)
          --
          -- vim.notify(vim.inspect(note_path))
          -- vim.notify(vim.inspect(path))
          -- vim.notify(vim.inspect(path:relative_to(note_path)))
          -- vim.notify(vim.inspect(note_path:relative_to(path)))
        end,
      },
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        -- Add the create date and time to the frontmatter if they don't exist.
        --  because file's mtime is not reliable in some cases. For example, when you copy a file
        if not out.created_at then
          out.created_at = os.date("%Y-%m-%d %H:%M")
        end

        if not out.title then
          out.title = note.id
        end

        if not out.slug then
          out.slug = note.id
        end

        if not out.description then
          out.description = ""
        end
        -- always update update_date and update_time
        out.updated_at = os.date("%Y-%m-%d %H:%M")

        return out
      end,
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):lower()
          -- 会把中文移除了
          -- :gsub("[^A-Za-z0-9-]", ""):
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      --  不要修改这个函数,因为 obsidian.nvim 是通过文件名和id 一致来确定连接的. 我们只能改 note_id_func 来修改文件名
      -- note_path_func = function(spec)
      --   -- if spec's title exist using it, otherwise using id instead
      --   local identifier = spec.title and spec.title or tostring(spec.id)
      --   local path = spec.dir / tostring(spec.id)
      --   return path:with_suffix(".md")
      -- end,
      workspaces = {
        {
          name = "personal",
          path = function()
            local maybe_path = {
              "~/source/personal/obsidian/",
              "~/Source/obsidian/",
              "~/source/obsidian/",
            }

            for _, path in ipairs(maybe_path) do
              if vim.fn.isdirectory(vim.fn.expand(path)) == 1 then
                return vim.fn.expand(path)
              end
            end
          end,
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    lazy = true,
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
  },

  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
}
