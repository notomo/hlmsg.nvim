local M = {}

--- Render highlighted message history to the given buffer.
--- @param bufnr number: modifiable buffer number
--- @param opts table|nil: currently, only used by testing
function M.render(bufnr, opts)
  require("hlmsg.command").render(bufnr, opts)
end

return M
