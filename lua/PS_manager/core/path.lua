local lib = require("PS_manager.core.lib")
-- local current_path = vim.fn.getcwd()
local current_path = nil

local set_lock = false

local function lock_set_path()
	set_lock = true
end

local function unlock_set_path()
	set_lock = false
end

local function set_current_path(path)
	if set_lock then
		return
	end
	current_path = path
end

local function get_current_path()
	return current_path
end

local buffer_path_id = {}

local function get_path_id_by_buffer(buffer)
	return buffer_path_id[buffer] or nil
end

local function add_path_id_by_buffer(buffer, path_id)
	buffer_path_id[buffer] = path_id
end

local function del_buffer(buffer)
	buffer_path_id[buffer] = nil
end

-- {
-- 	id = {
-- 		num = 1,
-- 		path = "",
-- 	},
-- }
local id_to_path_arr = {}

-- path - id
local path_to_id_arr = {}

local function get_path_by_id(id)
	if id_to_path_arr[id] then
		return id_to_path_arr[id].path
	end
	return nil
end

local function get_id_by_path(path)
	return path_to_id_arr[path] or nil
end

local function add_path(path)
	local id
	if path_to_id_arr[path] then
		id = path_to_id_arr[path]
		id_to_path_arr[id].num = id_to_path_arr[id].num + 1
	else
		local previous_num = #id_to_path_arr
		id = previous_num + 1
		id_to_path_arr[id] = {
			num = 1,
			path = path,
		}
		path_to_id_arr[path] = id
	end
	return id
end

local function del_path(path)
	local id = path_to_id_arr[path] or -1
	if id ~= -1 then
		id_to_path_arr[id].num = id_to_path_arr[id].num - 1
		if id_to_path_arr[id].num == 0 then
			id_to_path_arr[id] = nil
			path_to_id_arr[path] = nil
		end
	end
end

return {
	get_path_id_by_buffer = get_path_id_by_buffer,
	add_path_id_by_buffer = add_path_id_by_buffer,
	del_buffer = del_buffer,
	set_current_path = set_current_path,
	get_current_path = get_current_path,
	get_path_by_id = get_path_by_id,
	get_id_by_path = get_id_by_path,
	del_path = del_path,
	add_path = add_path,
	lock_set_path = lock_set_path,
	unlock_set_path = unlock_set_path,
}
