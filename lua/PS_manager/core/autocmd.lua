local lsp, fn, api = vim.lsp, vim.fn, vim.api

local M = {}

local lib = require("PS_manager.core.lib")
local path = require("PS_manager.core.path")

api.nvim_create_autocmd({ "BufAdd" }, {
	-- Just after creating a new buffer which is
	-- added to the buffer list, or adding a buffer
	-- to the buffer list, a buffer in the buffer
	-- list was renamed.

	callback = function()
		if path.get_current_path() == nil then
			return
		end
		local buffer = tonumber(fn.expand("<abuf>"))

		local path_id = path.get_id_by_path(path.get_current_path())
		if path_id == nil then
			path_id = path.add_path(path.get_current_path())
		else
			path.add_path(path.get_path_by_id(path_id))
		end
		path.add_path_id_by_buffer(buffer, path_id)
	end,
	desc = lib.Command_des("when buffer add list, add path info"),
})

api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
		local buffer = tonumber(fn.expand("<abuf>"))
		-- if current buffer is not listed, return
		local listed_buffer = lib.Get_listed_buffers()
		if not lib.Tb_has_value(listed_buffer, buffer) then
			return
		end
		local path_id = path.get_path_id_by_buffer(buffer)
		if path_id == nil then
			return
		end
        local current_path = path.get_path_by_id(path_id)
		api.nvim_set_current_dir(current_path)
	end,
})

api.nvim_create_autocmd({ "BufDelete" }, {
	-- group = group_id,
	callback = function()
		local buffer = tonumber(fn.expand("<abuf>"))

		local path_id = path.get_path_id_by_buffer(buffer)
		if path_id == nil then
			return
		end
		path.del_buffer(buffer)
		local current_path = path.get_path_by_id(path_id)
		path.del_path(current_path)
	end,
	desc = lib.Command_des("Exec clean cmd when QuitPre"),
})

return M
