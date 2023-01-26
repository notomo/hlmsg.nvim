local M = {}

--- Renders highlighted message history to the given buffer.
--- @param bufnr number: modifiable buffer number
function M.render(bufnr)
  require("hlmsg.command").render(bufnr)
end

--- Returns highlighted text chunks.
--- @return table: {
---   kind = string,
---   line = string,
---   chunks = {
---     text = string,
---     hl_group = string,
---     start_col = number,
---     end_col = number
---   }[]
--- }[]
function M.get()
  return require("hlmsg.command").get()
end

return M
