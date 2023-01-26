local lsp, fn, api, uv = vim.lsp, vim.fn, vim.api, vim.loop
local lib = require("PS_manager.core.lib")
local version = "0.0.1"

local M = {}

M.version = function()
	return version
end

M.config = {
	datapath = vim.fn.stdpath("data"),
	projects = {},
}

local projects = {}

M.get_projects = function()
	return projects
end

local function readFile(path, callback)
	uv.fs_open(path, "r", 438, function(_, fd)
		uv.fs_fstat(fd, function(_, stat)
			uv.fs_read(fd, stat.size, 0, function(_, data)
				uv.fs_close(fd, function(_)
					return callback(data)
				end)
			end)
		end)
	end)
end

local function check_data_dir_exist()
	uv.fs_stat(M.config.datapath .. "/PS_manager", function(_, stat)
		if stat == nil then
			uv.fs_mkdir(M.config.datapath .. "/PS_manager", 448)
		end
	end)
end

M.read = function()
	check_data_dir_exist()
	readFile(M.config.datapath .. "/PS_manager" .. "/project", function(data)
		local file_projects = {}
		for s in string.gmatch(data, "[^\r\n]+") do
			if lib.Dir_exists(s) then
				table.insert(file_projects, s)
			end
		end
		for key, value in pairs(M.config.projects) do
			table.insert(file_projects, value)
		end
		projects = file_projects
	end)
end

return M
