local M = {}

function M.add(ns, bufnr, entries)
  for i, entry in ipairs(entries) do
    local _, contents = unpack(entry)
    local start_col = 0
    for _, pair in ipairs(contents) do
      local hl_id, text = unpack(pair)
      local end_col = start_col + vim.fn.strdisplaywidth(text)
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, start_col, {
        hl_group = hl_id,
        end_col = end_col,
      })
      start_col = end_col
    end
  end
end

return M
