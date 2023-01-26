local version = "0.0.1"

local M = {}

M.version = function()
	return version
end

M.config = {
	datapath = vim.fn.stdpath("data"),
	projects = {},
}

return M
