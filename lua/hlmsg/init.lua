local M = {}

--- Renders highlighted message history to the given buffer.
--- @param bufnr number: modifiable buffer number
function M.render(bufnr)
  require("hlmsg.command").render(bufnr)
end

--- @class HlmsgMessage
--- @field kind string: |ui-messages|'s kind
--- @field line string: message splitted by newline
--- @field chunks HlmsgChunk[] |HlmsgChunk|

--- @class HlmsgChunk
--- @field text string chunked text
--- @field hl_group string highlight group
--- @field start_col integer 0-based index column
--- @field end_col integer 0-based index column

--- Returns highlighted text chunks.
--- @return HlmsgMessage[]: |HlmsgMessage|
function M.get()
  return require("hlmsg.command").get()
end

return M
