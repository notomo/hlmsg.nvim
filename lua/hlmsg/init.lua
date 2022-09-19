local M = {}

--- Render highlighted message history to the given buffer.
--- @param bufnr number: modifiable buffer number
function M.render(bufnr)
  require("hlmsg.command").render(bufnr)
end

return M
