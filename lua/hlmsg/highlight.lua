local M = {}

-- HACK

local ffi = require("ffi")
local setup_ffi = function()
  -- The following cdef code is from https://github.com/neovim/neovim/blob/c126c1f73a0bae3ac40ce460ef303348a671a08f/src/nvim/highlight_defs.h .
  -- Its license is https://www.apache.org/licenses/LICENSE-2.0 .
  ffi.cdef([[
typedef int32_t RgbValue;
typedef struct attr_entry {
  int16_t rgb_ae_attr, cterm_ae_attr;
  RgbValue rgb_fg_color, rgb_bg_color, rgb_sp_color;
  int cterm_fg_color, cterm_bg_color;
  int hl_blend;
} HlAttrs;
HlAttrs syn_attr2entry(int attr);
]])
end
local ok, err = pcall(setup_ffi)
if not ok and not err:find("redefine") then
  error(err)
end

local C = ffi.C
local nvim_set_hl = vim.api.nvim_set_hl
function M._attr_id_to_hl_group(attr_id)
  local attributes = C.syn_attr2entry(attr_id)
  local hl_group = "HlmsgAttribute" .. tostring(attr_id)

  local blend = attributes.hl_blend
  if blend == -1 then
    blend = nil
  end

  nvim_set_hl(0, hl_group, {
    fg = attributes.rgb_fg_color,
    bg = attributes.rgb_bg_color,
    sp = attributes.rgb_sp_color,
    reverse = bit.band(attributes.rgb_ae_attr, 0x01),
    bold = bit.band(attributes.rgb_ae_attr, 0x02),
    italic = bit.band(attributes.rgb_ae_attr, 0x04),
    underline = bit.band(attributes.rgb_ae_attr, 0x08),
    undercurl = bit.band(attributes.rgb_ae_attr, 0x10),
    underdouble = bit.band(attributes.rgb_ae_attr, 0x20),
    underdotted = bit.band(attributes.rgb_ae_attr, 0x40),
    underdashed = bit.band(attributes.rgb_ae_attr, 0x80),
    standout = bit.band(attributes.rgb_ae_attr, 0x0100),
    nocombine = bit.band(attributes.rgb_ae_attr, 0x0200),
    strikethrough = bit.band(attributes.rgb_ae_attr, 0x0400),
    blend = blend,
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
      local attr_id, text_chunk = unpack(pair)
      local hl_group = M._attr_id_to_hl_group(attr_id)
      local lines = vim.split(text_chunk, "\n", true)
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
