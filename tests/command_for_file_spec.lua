local assert = require 'luassert'

describe('command_for_file()', function ()
  local util
  local tooltip
  local patterns

  before_each(function ()
    util = require 'tooltip.util'
    tooltip = require 'tooltip'

  end)

  it('return command for file with extension pattern: set up', function ()
    tooltip.setup {
      patterns = {
        ['.js'] = 'node %s'
      }
    }

    local file = 'test.js'
    local command = util._command_for_file(file)

    assert.are.same({'node', 'test.js'}, command)
  end)

  it('return error for file with extension pattern: not set up', function ()
    tooltip.setup {}

    local file = 'test.notsetup'

    assert.has_error(function ()
      util._command_for_file(file)
    end, 'command pattern not set up for this file extension')
  end)

  it('return command given a file with extension pattern set up and a path that has multiple "."', function ()
    tooltip.setup {
      patterns = {
        ['.js'] = 'node %s'
      }
    }

    local file = '/path/to.file/with/extension.js'
    local expected = {'node', file}
    local command = util._command_for_file(file)

    assert.are.same(expected, command)
  end)

  it('return error given a file with extension pattern not set up and a path that has multiple "."', function ()
    tooltip.setup {}

    local file = '/path/to.file/with/extension.notsetup'

    assert.has_error(function ()
      util._command_for_file(file, patterns)
    end, 'command pattern not set up for this file extension')
  end)
end)
