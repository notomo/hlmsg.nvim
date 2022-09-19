local M = {}

--- Render highlighted message history to the given buffer.
--- @param bufnr number: modifiable buffer number
function M.render(bufnr)
  require("hlmsg.command").render(bufnr)
end

--- Render highlighted text chunks.
--- @return table: [text, hl_group][][]
function M.get()
  return require("hlmsg.command").get()
end

return M
