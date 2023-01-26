local lsp, fn, api, uv = vim.lsp, vim.fn, vim.api, vim.loop

local M = {}

M.Command_des = function(des)
	return "[PS_manager]: " .. des
end

M.Get_listed_buffers = function()
	local buffers_listed = {}
	local buffers = api.nvim_list_bufs()
	for _, value in pairs(buffers) do
		if fn.buflisted(value) == 1 then
			table.insert(buffers_listed, value)
		end
	end
	return buffers_listed
end

M.Tb_has_value = function(tb, val)
	for _, v in pairs(tb) do
		if v == val then
			return true
		end
	end
	return false
end

M.Dir_exists = function(dir)
	local stat = uv.fs_stat(dir)
	if stat ~= nil and stat.type == "directory" then
		return true
	end
	return false
end

M.Get_table_len = function(tbl)
	local count = 0
	for k, v in pairs(tbl) do
		count = count + 1
	end
	return count
end

M.debug = function(...)
	local date = os.date("%Y-%m-%d %H:%M:%S")
	local args = { ... }
	for _, value in pairs(args) do
		print(date, vim.inspect(value))
	end
end

return M
