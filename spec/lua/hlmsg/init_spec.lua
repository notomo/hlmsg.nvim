local helper = require("hlmsg.test.helper")
local hlmsg = helper.require("hlmsg")
local assert = require("assertlib").typed(assert)

describe("hlmsg.render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("renders message histories as lines", function()
    print("line1")
    print("line2")

    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr)

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.same(got, { "line1", "line2" })
  end)

  it("works when there is no message", function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    hlmsg.render(bufnr)

    local got = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.same(got, { "" })
  end)
end)

describe("hlmsg.get()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns highlight text chunks", function()
    vim.api.nvim_set_hl(0, "HlmsgTestLink", {
      link = "Search",
    })
    vim.api.nvim_echo({ { "line1" } }, true, {})
    vim.api.nvim_echo({ { "li" }, { "n\ne" }, { "2", "HlmsgTestLink" } }, true, {})

    local got = hlmsg.get()

    assert.same(got, {
      {
        line = "line1",
        kind = "echomsg",
        chunks = {
          {
            text = "line1",
            hl_group = "NONE",
            start_col = 0,
            end_col = 5,
          },
        },
      },
      {
        line = "lin",
        kind = "echomsg",
        chunks = {
          {
            text = "li",
            hl_group = "NONE",
            start_col = 0,
            end_col = 2,
          },
          {
            text = "n",
            hl_group = "NONE",
            start_col = 2,
            end_col = 3,
          },
        },
      },
      {
        line = "e2",
        kind = "echomsg",
        chunks = {
          {
            text = "e",
            hl_group = "NONE",
            start_col = 0,
            end_col = 1,
          },
          {
            text = "2",
            hl_group = "Search",
            start_col = 1,
            end_col = 2,
          },
        },
      },
    })
  end)
end)
