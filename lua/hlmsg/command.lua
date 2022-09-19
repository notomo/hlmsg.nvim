local ShowError = require("hlmsg.vendor.misclib.error_handler").for_show_error()

local ns = vim.api.nvim_create_namespace("hlmsg")

function ShowError.render(bufnr)
  local entries = require("hlmsg.message").get(ns)

  local lines = require("hlmsg.message").to_lines(entries)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  require("hlmsg.highlight").add(ns, bufnr, entries)
end

return ShowError:methods()
