require 'tooltip.user-commands'
local util = require 'tooltip.util'

local M = {}

local MinWidth = 6
local MinHeight = 1

M.win_config = {
  relative = 'cursor',
  row = 1,
  col = 0,
  anchor = 'NW',
  style = 'minimal',
}

M.setup = function (config)
  M.styled = config['styled'] or false

  M.win_config.title = M.styled and 'output' or ''
  M.win_config.border = M.styled and 'rounded' or 'none'

  util._merge_tables(config['patterns'])
end

M._run = function (command)
  vim.api.nvim_notify('running '..command, 0, {})

  local command_table = util._table_of(command)

  local obj = vim.system(command_table, {
    text = true,
    detach = false,
  }):wait()

  local stdout_table = {}
  local stderr_table = {}

  if obj.stdout ~= '' then
    stdout_table = util._table_of(obj.stdout, '\n')
  end

  if obj.stderr ~= '' then
    stderr_table = util._table_of(obj.stderr, '\n')
  end

  local merged_tables = util._table_concat(stdout_table, stderr_table)

  M.win_config.width = math.max(util._longest_line(merged_tables), MinWidth)
  M.win_config.height = math.max(#merged_tables, MinHeight)

  vim.api.nvim_notify('finished running', 0, {})

  return table.concat(merged_tables, '\n')
end

M._open_win = function ()
  M.output_buffer = vim.api.nvim_create_buf(true, true)
  M.win_id = vim.api.nvim_open_win(M.output_buffer, true, M.win_config)
  M.term_id = vim.api.nvim_open_term(M.output_buffer, {})
end

M._write = function(data)
  vim.api.nvim_chan_send(M.term_id, data)
end

M.show = function ()
  vim.cmd('w')

  local file = util._file_name(0)
  local command = util._command_for_file(file)
  local output = M._run(command)

  M._open_win()
  M._write(output)

  vim.api.nvim_buf_set_keymap(M.output_buffer, 'n', 'q', '', {
    callback = function ()
      require('tooltip').close()
    end
  })
end

M.close = function ()
  vim.api.nvim_win_close(M.win_id, true)
  vim.api.nvim_buf_delete(M.output_buffer, { force = true })
end

return M
