local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

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

function helper.on_finished()
  local finished = false
  return setmetatable({
    wait = function()
      local ok = vim.wait(1000, function()
        return finished
      end, 10, true)
      if not ok then
        error("wait timeout")
      end
    end,
  }, {
    __call = function()
      finished = true
    end,
  })
end

return helper
