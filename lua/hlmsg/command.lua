local ShowError = require("hlmsg.vendor.misclib.error_handler").for_show_error()
local ReturnValue = require("hlmsg.vendor.misclib.error_handler").for_return_value()

local ns = vim.api.nvim_create_namespace("hlmsg")

function ShowError.render(bufnr)
  local entries = require("hlmsg.message").get(ns)
  local messages = require("hlmsg.highlight").messages(entries)

  local lines = vim.tbl_map(function(message)
    return message.line
  end, messages)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  require("hlmsg.highlight").add(ns, bufnr, messages)
end

function ReturnValue.get()
  local entries = require("hlmsg.message").get(ns)
  return require("hlmsg.highlight").messages(entries)
end

return vim.tbl_extend("force", ShowError:methods(), ReturnValue:methods())
