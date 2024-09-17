local M = {}

function M.get(ns)
  vim.ui_detach(ns)

  local has_messages = vim.api.nvim_exec2("messages", { output = true }).output ~= ""
  if not has_messages then
    return {}
  end

  local cmdheight = vim.o.cmdheight
  local entries = {}
  ---@diagnostic disable-next-line: redundant-parameter
  vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
    if event ~= "msg_history_show" then
      return
    end

    -- to close press ENTER prompt
    local press_enter = vim.keycode("<Cmd><CR>")
    vim.api.nvim_feedkeys(press_enter, "nt", true)

    vim.ui_detach(ns)
    -- currently, cmdheight is changed by ui_attach
    vim.o.cmdheight = cmdheight

    entries = ...
  end)

  vim.cmd.messages()

  -- to hide press ENTER message
  vim.api.nvim_echo({ { "" } }, false, {})

  return entries
end

return M
