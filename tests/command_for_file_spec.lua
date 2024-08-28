local assert = require 'luassert'

describe('command_for_file()', function ()
  local tooltip

  before_each(function ()
    tooltip = require 'tooltip'
    tooltip._clear()
  end)

  it('return command for file with extension pattern: set up', function ()
    tooltip.setup({
      patterns = {
        ['.js'] = 'node %s',
      },
    })

    local file = 'test.js'
    local command = tooltip._command_for_file(file)

    assert.equal('node test.js', command)
  end)

  it('return error for file with extension pattern: not set up', function ()
    local file = 'test.js'

    assert.has_error(function ()
      tooltip._command_for_file(file)
    end, 'command pattern not set up for this file extension')
  end)

  it('return command given a file with extension pattern set up and a path that has multiple "."', function ()
    tooltip.setup ({
      patterns = {
        ['.js'] = 'node %s',
      }
    })

    local file = '/path/to.file/with/extension.js'
    local expected = string.format('node %s', file)
    local command = tooltip._command_for_file(file)

    assert.equal(expected, command)
  end)

  it('return error given a file with extension pattern not set up and a path that has multiple "."', function ()
    local file = '/path/to.file/with/extension.js'

    assert.has_error(function ()
      tooltip._command_for_file(file)
    end, 'command pattern not set up for this file extension')
  end)
end)
