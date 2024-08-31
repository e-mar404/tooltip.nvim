local assert = require 'luassert'

describe('table_of', function ()
  local util

  before_each(function ()
    util = require 'tooltip.util'
  end)

  it('gets an empty string and returns a table with a single empty string', function ()
    local data = ''
    local expected = { '' }
    local actual = util._table_of(data)

    assert.are.same(actual, expected)
  end)

  it('defaults to using the space as separator', function ()
    local data = 'testing spaces as separator'
    local expected = { 'testing', 'spaces', 'as', 'separator' }
    local actual = util._table_of(data)

    assert.are.same(expected, actual)
  end)

  it('is able to separate by new lines', function ()
    local data = 'testing\nnew\nlines'
    local separator = '\n'
    local expected = { 'testing', 'new', 'lines' }
    local actual = util._table_of(data, separator)

    assert.are.same(expected, actual)
  end)
end)