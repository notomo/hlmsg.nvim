local M = {}

function M.get(ns, callback)
  vim.ui_detach(ns)

  local has_messages = vim.api.nvim_exec("messages", true) ~= ""
  if not has_messages then
    callback({})
    return nil
  end

  local cmdheight = vim.o.cmdheight
  vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
    if event ~= "msg_history_show" then
      return
    end

    -- to close press ENTER prompt
    local press_enter = vim.api.nvim_replace_termcodes("<Cmd><CR>", true, false, true)
    vim.api.nvim_feedkeys(press_enter, "nt", true)

    vim.ui_detach(ns)
    -- currently, cmdheight is changed by ui_attach
    vim.o.cmdheight = cmdheight

    local entries = ...
    callback(entries)
  end)

  vim.cmd.messages()

  -- to hide press ENTER message
  vim.api.nvim_echo({ { "" } }, false, {})
end

function M.to_lines(entries)
  local lines = {}
  for _, entry in ipairs(entries) do
    local _, contents = unpack(entry)
    local line = {}
    for _, content in ipairs(contents) do
      local _, message = unpack(content)
      table.insert(line, message)
    end
    table.insert(lines, table.concat(line, ""))
  end
  return lines
end

return M
