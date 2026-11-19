-- Neo-tree source: "git_round"
--
-- A git_status clone that shows only the changes which are NOT staged yet
-- (worktree vs index, i.e. what `git diff` reports) plus untracked files —
-- in other words exactly what changed since the last `git add`, which is the
-- round of agent edits you still have to review.
--
-- Vendored from neo-tree's own git_status source (v3.x, lua/neo-tree/sources/
-- git_status/lib/items.lua) with one filter added, so that expansion state,
-- file watcher, git events and renderers behave exactly like the built-in
-- source. If neo-tree changes that internals this may need re-syncing.
local renderer = require("neo-tree.ui.renderer")
local file_items = require("neo-tree.sources.common.file-items")
local log = require("neo-tree.log")
local git = require("neo-tree.git")
local utils = require("neo-tree.utils")
local events = require("neo-tree.events")
local manager = require("neo-tree.sources.manager")

---@class neotree.sources.GitRound : neotree.Source
local M = {
  name = "git_round",
  display_name = " 󰊢 Round ",
}

local function get_state()
  return manager.get_state(M.name)
end

-- status is neo-tree's porcelain code: [index][worktree] with "." standing in
-- for a space (parsers.lua does XY:gsub(" ", ".")), so "M." = staged only,
-- ".M" = worktree only, "MM" = both, "??" = untracked.
-- Keep a file when its worktree column still differs from the index, so
-- staged-only files ("M.", "A.") drop out of the list.
---@param status any
---@return boolean
local function is_this_round(status)
  if type(status) ~= "string" or status == "" then
    return false
  end
  if status == "??" then
    return true
  end
  if status:sub(1, 1) == "!" then -- ignored
    return false
  end
  return status:sub(2, 2) ~= "."
end

-- Same body as git_status's get_git_status, with the filter applied while
-- walking the status lookup.
local function get_git_round(state)
  if state.loading then
    return
  end
  state.loading = true
  local status_lookup, project_root, status_lookup_over_base =
    git.status(state.path, state.git_base_by_worktree, false, { untracked_files = "all" })
  state.path = project_root or state.path or vim.fn.getcwd()
  local context = file_items.create_context()
  context.state = state
  local root = file_items.create_item(context, state.path, "directory")
  root.name = vim.fn.fnamemodify(root.path, ":~")
  root.loaded = true
  root.search_pattern = state.search_pattern
  context.folders[root.path] = root

  local status_lookups = {}
  if status_lookup then
    status_lookups[#status_lookups + 1] = status_lookup
  end
  if status_lookup_over_base then
    status_lookups[#status_lookups + 1] = status_lookup_over_base
  end
  for _, lookup in ipairs(status_lookups) do
    for path, status in pairs(lookup) do
      if is_this_round(status) then
        local ok, item = pcall(file_items.create_item, context, path)
        if not ok then
          log.error("git_round: failed to create item for " .. path .. ": " .. item)
        else
          if item.type == "unknown" then
            item.type = "file"
          end
          item.status = nil
          item.extra = { git_status = status }
        end
      end
    end
  end

  state.default_expanded_nodes = {}
  for id, _ in pairs(context.folders) do
    table.insert(state.default_expanded_nodes, id)
  end
  file_items.advanced_sort(root.children, state)
  renderer.show_nodes({ root }, state)
  state.loading = false
end

---Navigate to the given path.
---@param state neotree.State
---@param path string? Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path, path_to_reveal, callback, async)
  state.path = path or state.path
  state.dirty = false
  if path_to_reveal then
    renderer.position.set(state, path_to_reveal)
  end
  get_git_round(state)
  if type(callback) == "function" then
    vim.schedule(callback)
  end
end

M.refresh = function()
  manager.refresh(M.name)
end

---@param config neotree.Config.Source
---@param global_config neotree.Config.Base
M.setup = function(config, global_config)
  if config.before_render then
    local this_state
    manager.subscribe(M.name, {
      event = events.BEFORE_RENDER,
      handler = function(state)
        this_state = this_state or get_state()
        if state == this_state then
          config.before_render(this_state)
        end
      end,
    })
  end
  if global_config.enable_refresh_on_write then
    manager.subscribe(M.name, {
      event = events.VIM_BUFFER_CHANGED,
      handler = function(args)
        if utils.is_real_file(args.afile) then
          M.refresh()
        end
      end,
    })
  end
  manager.subscribe(M.name, {
    event = events.GIT_EVENT,
    handler = M.refresh,
  })
end

return M
