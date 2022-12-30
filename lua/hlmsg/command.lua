local M = {}

local ns = vim.api.nvim_create_namespace("hlmsg")

function M.render(bufnr)
  local entries = require("hlmsg.message").get(ns)
  local messages = require("hlmsg.highlight").messages(entries)

  local lines = vim.tbl_map(function(message)
    return message.line
  end, messages)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  require("hlmsg.highlight").add(ns, bufnr, messages)
end

function M.get()
  local entries = require("hlmsg.message").get(ns)
  return require("hlmsg.highlight").messages(entries)
end

return M
