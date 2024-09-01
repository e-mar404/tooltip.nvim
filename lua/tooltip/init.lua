local util = require 'tooltip.util'

local M = {}
local patterns = {}
local output_buffer
local win_id
local styled = false

M.setup = function (config)
  patterns = config['patterns']
  styled = config['styled']
end

M._run = function (command)
  output_buffer = tonumber(vim.api.nvim_create_buf(true, true))

  local command_table = util._table_of(command)

  local obj = vim.system(command_table, {
    text = true,
  }):wait()

  util._write_to_buf(output_buffer, obj.stdout)
end

M._open_win = function ()
  local lines = vim.api.nvim_buf_get_lines(output_buffer, 0, -1, true)
  local width = util._longest_line(lines)
  local height = vim.api.nvim_buf_line_count(output_buffer)

  local config = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = width,
    height = height,
    anchor = 'NW',
    style = 'minimal',
    border = styled and 'rounded' or 'none',
    title = styled and 'output' or '',
  }

  win_id = vim.api.nvim_open_win(output_buffer, true, config)
end


M.show = function ()
  local file = util._file_name(0)
  local command = util._command_for_file(file, patterns)
  M._run(command)

  vim.api.nvim_buf_set_keymap(output_buffer, 'n', '<leader>q', '', {
    callback = function ()
      require('tooltip').close()
    end
  })

  M._open_win()
end

M.close = function ()
  vim.api.nvim_win_close(win_id, true)
  vim.api.nvim_buf_delete(output_buffer, {})
end

M._clear = function ()
  patterns = {}
end

return M
