-- Components for the "git_round" source.
-- Copied from neo-tree's git_status source, with the root title renamed so the
-- tree header says what this view actually is.
local highlights = require("neo-tree.ui.highlights")
local common = require("neo-tree.sources.common.components")

---@type table<string, neotree.Renderer>
local M = {}

---@class (exact) neotree.Component.GitRound.Name : neotree.Component.Common.Name
---@field [1] "current_filter"?
---@field use_git_status_colors boolean?

---@param config neotree.Component.GitRound.Name
M.name = function(config, node, state)
  local highlight = config.highlight or highlights.FILE_NAME_OPENED
  local name = node.name
  if node.type == "directory" then
    if node:get_depth() == 1 then
      highlight = highlights.ROOT_NAME
      if node:has_children() then
        name = "UNSTAGED for " .. name
      else
        name = "UNSTAGED (nothing to review) for " .. name
      end
    else
      highlight = highlights.DIRECTORY_NAME
    end
  elseif config.use_git_status_colors then
    local git_status = state.components.git_status({}, node, state)
    if git_status and git_status.highlight then
      highlight = git_status.highlight
    end
  end
  return {
    text = name,
    highlight = highlight,
  }
end

return vim.tbl_deep_extend("force", common, M)
