local ShowError = require("hlmsg.vendor.misclib.error_handler").for_show_error()

local ns = vim.api.nvim_create_namespace("hlmsg")

function ShowError.render(bufnr, opts)
  opts = opts or {}
  opts.on_finished = opts.on_finished or function() end

  require("hlmsg.message").get(ns, function(entries)
    local lines = require("hlmsg.message").to_lines(entries)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    require("hlmsg.highlight").add(ns, bufnr, entries)

    opts.on_finished()
  end)
end

return ShowError:methods()
