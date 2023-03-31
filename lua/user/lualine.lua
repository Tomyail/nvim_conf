local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local gps_ok, gps = pcall(require, "nvim-gps")
local bar_c
if gps_ok then
	bar_c = {
		{ gps.get_location, cond = gps.is_available },
	}
else
	bar_c = {}
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = true,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local function lsp_client_names()
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = {}
	for _, client in ipairs(vim.lsp.get_active_clients()) do
		if client.config.filetypes and vim.tbl_contains(client.config.filetypes, buf_ft) then
			table.insert(clients, client.name)
		end
	end
	return table.concat(clients, ", ")
end

lualine.setup({
	options = {
		icons_enabled = true,
		-- theme = "auto",
		--[[ theme = "dracula", ]]
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "defx" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { branch, diagnostics },
		lualine_b = { mode },
		lualine_c = {
			lsp_client_names,
		},
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = {
			diff,
			spaces,
			"encoding",
			filetype,
		},
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
