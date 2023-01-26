local has_telescope, telescope = pcall(require, "telescope")
local core = require("PS_manager.core")
if not has_telescope then
	return
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local core = require("PS_manager.core")
local config = require("PS_manager.config")

local function create_finder()
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{
				width = 30,
			},
			{
				remaining = true,
			},
		},
	})

	local function make_display(entry)
		return displayer({ entry.name, { entry.value, "Comment" } })
	end

	return finders.new_table({
		results = config.get_projects(),
		entry_maker = function(entry)
			local name = vim.fn.fnamemodify(entry, ":t")
			return {
				display = make_display,
				name = name,
				value = entry,
				ordinal = name .. " " .. entry,
			}
		end,
	})
end

local function change_working_directory(prompt_bufnr, prompt)
	local selected_entry = action_state.get_selected_entry(prompt_bufnr)
	if selected_entry == nil then
		actions.close(prompt_bufnr)
		return
	end
	local project_path = selected_entry.value
	if prompt == true then
		actions._close(prompt_bufnr, true)
	else
		actions.close(prompt_bufnr)
	end
	vim.api.nvim_set_current_dir(project_path)
	core.path.set_current_path(project_path)
	return project_path
end

local function find_project_files(prompt_bufnr)
	local project_path = change_working_directory(prompt_bufnr, true)
	local opt = {
		cwd = project_path,
		-- hidden = config.options.show_hidden,
		mode = "insert",
	}

	builtin.find_files(opt)
end

-- picker function:
local PS_manager = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Projects",
			finder = create_finder(),
			attach_mappings = function(prompt_bufnr, map)
				local on_project_selected = function()
					find_project_files(prompt_bufnr)
				end
				actions.select_default:replace(on_project_selected)
				return true
			end,
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return telescope.register_extension({
	exports = {
		PS_manager = PS_manager,
	},
})
