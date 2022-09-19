local helper = require("hlmsg.test.helper")
local hlmsg = helper.require("hlmsg")

describe("hlmsg.render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("renders message histories as lines", function()
    print("line1")
    print("line2")

    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr)

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.is_same(got, { "line1", "line2" })
  end)

  it("works when there is no message", function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr)

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.is_same(got, { "" })
  end)
end)

describe("hlmsg.get()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns highlight text chunks", function()
    print("line1")
    vim.api.nvim_echo({ { "li" }, { "ne2" } }, true, {})

    local got = hlmsg.get()

    assert.is_same(got, {
      {
        { "line1", "HlmsgAttribute0" },
      },
      {
        { "li", "HlmsgAttribute0" },
        { "ne2", "HlmsgAttribute0" },
      },
    })
  end)
end)
