local helper = require("hlmsg.test.helper")
local hlmsg = helper.require("hlmsg")

describe("hlmsg.render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("renders message histories as lines", function()
    print("line1")
    print("line2")

    local on_finished = helper.on_finished()
    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr, { on_finished = on_finished })
    on_finished:wait()

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.is_same(got, { "line1", "line2" })
  end)

  it("works when there is no message", function()
    local on_finished = helper.on_finished()
    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr, { on_finished = on_finished })
    on_finished:wait()

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.is_same(got, { "" })
  end)
end)
