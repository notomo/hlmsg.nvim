local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

function helper.before_each() end

function helper.after_each()
  local log_file_path = os.getenv("HLMSG_TEST_LOG")
  if log_file_path then
    local f = io.open(log_file_path, "a")
    local log = vim.api.nvim_exec("messages", true)
    f:write(log .. "\n")
  end
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
end

return helper
