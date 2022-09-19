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
    bold = bit.band(attributes.rgb_ae_attr, 0x02),
    blend = blend,
  })
  return hl_group
end

function M.to_chunks(entries)
  local chunks = {}
  for _, entry in ipairs(entries) do
    local chunk = {}
    local _, contents = unpack(entry)
    for _, pair in ipairs(contents) do
      local attr_id, text = unpack(pair)
      local hl_group = M._attr_id_to_hl_group(attr_id)
      table.insert(chunk, { text, hl_group })
    end
    table.insert(chunks, chunk)
  end
  return chunks
end

local nvim_buf_set_extmark = vim.api.nvim_buf_set_extmark
function M.add(ns, bufnr, entries)
  local chunks = M.to_chunks(entries)
  for i, chunk in ipairs(chunks) do
    local start_col = 0
    for _, pair in ipairs(chunk) do
      local text, hl_group = unpack(pair)
      local end_col = start_col + vim.fn.strdisplaywidth(text)
      nvim_buf_set_extmark(bufnr, ns, i - 1, start_col, {
        hl_group = hl_group,
        end_col = end_col,
      })
      start_col = end_col
    end
  end
end

return M
