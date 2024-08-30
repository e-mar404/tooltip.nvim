local util = require 'tooltip.util'

local M = {}
local patterns = {}

M.setup = function (config)
  patterns = config['patterns']
end

M._run = function (command)
  local output_buffer = tonumber(vim.api.nvim_create_buf(true, true))

  local command_table = util._table_of(command)

  local obj = vim.system(command_table, {
    text = true,
  }):wait()

  util._write_to_buf(output_buffer, obj.stdout)

  return output_buffer
end

M._open_win = function (output_buffer)
  local line_num = vim.api.nvim_buf_line_count(output_buffer)

  local opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = 30,
    height = line_num,
    anchor = 'NW',
    style = 'minimal',
  }

  vim.api.nvim_open_win(output_buffer, true, opts)
end


M.show = function ()
  local file = util._file_name(0)
  local command = util._command_for_file(file, patterns)
  local output_buffer = M._run(command)

  M._open_win(output_buffer)
end

M._clear = function ()
  patterns = {}
end

return M
