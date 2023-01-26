local config = require("PS_manager.config")
local M = {}

M.setup = function(opt)
	if opt ~= nil then
		config.config = vim.tbl_deep_extend("force", config.config, opt)
	end
	config.read()
	require("PS_manager.core")
end

return M
