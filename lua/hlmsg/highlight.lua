local M = {}

local nvim_set_hl = vim.api.nvim_set_hl
function M._attr_id_to_hl_group(hl_id)
  if hl_id == 0 then
    return "NONE"
  end

  local hl = vim.api.nvim_get_hl(0, { id = hl_id, link = true, create = false })
  if hl.link then
    return hl.link
  end

  local hl_group = "Hlmsg" .. tostring(hl_id)
  nvim_set_hl(0, hl_group, {
    fg = hl.fg,
    bg = hl.bg,
    sp = hl.sp,
    reverse = hl.reverse,
    bold = hl.bold,
    italic = hl.italic,
    underline = hl.underline,
    undercurl = hl.undercurl,
    underdouble = hl.underdouble,
    underdotted = hl.underdotted,
    underdashed = hl.underdashed,
    standout = hl.standout,
    nocombine = hl.nocombine,
    strikethrough = hl.reverse,
    blend = hl.blend,
  })
  return hl_group
end

local new_state = function()
  return {
    start_col = 0,
    texts = {},
    chunks = {},
  }
end

local new_message = function(kind, state)
  return {
    kind = kind,
    line = table.concat(state.texts, ""),
    chunks = state.chunks,
  }
end

local add_chunk = function(text, hl_group, state)
  local texts = {}
  vim.list_extend(texts, state.texts)
  table.insert(texts, text)

  local chunks = {}
  vim.list_extend(chunks, state.chunks)
  local end_col = state.start_col + #text
  table.insert(chunks, {
    text = text,
    hl_group = hl_group,
    start_col = state.start_col,
    end_col = end_col,
  })

  return {
    start_col = end_col,
    texts = texts,
    chunks = chunks,
  }
end

function M.messages(entries)
  local messages = {}
  for _, entry in ipairs(entries) do
    local state = new_state()
    local kind, contents = unpack(entry)
    for _, pair in ipairs(contents) do
      local _, text_chunk, hl_id = unpack(pair)
      local hl_group = M._attr_id_to_hl_group(hl_id)
      local lines = vim.split(text_chunk, "\n", { plain = true })
      state = add_chunk(lines[1], hl_group, state)
      for _, line in ipairs(vim.list_slice(lines, 2)) do
        table.insert(messages, new_message(kind, state))
        state = add_chunk(line, hl_group, new_state())
      end
    end
    table.insert(messages, new_message(kind, state))
  end
  return messages
end

local nvim_buf_set_extmark = vim.api.nvim_buf_set_extmark
function M.add(ns, bufnr, messages)
  for i, message in ipairs(messages) do
    for _, chunk in ipairs(message.chunks) do
      nvim_buf_set_extmark(bufnr, ns, i - 1, chunk.start_col, {
        hl_group = chunk.hl_group,
        end_col = chunk.end_col,
      })
    end
  end
end

return M
