local util = require 'tooltip.util'

local M = {}

M.win_config = {
  relative = 'cursor',
  row = 1,
  col = 0,
  width = 50,
  height = 2,
  anchor = 'NW',
  style = 'minimal',
}

M.setup = function (config)
  M.patterns = config['patterns'] or {}
  M.styled = config['styled'] or false

  M.win_config.title = M.styled and 'output' or ''
  M.win_config.border = M.styled and 'rounded' or 'none'
end

M._open_win = function ()
  M.output_buffer = vim.api.nvim_create_buf(true, true)
  M.win_id = vim.api.nvim_open_win(M.output_buffer, true, M.win_config)
  M.term_id = vim.api.nvim_open_term(M.output_buffer, {})
end

M._run = function (command)
  local command_table = util._table_of(command)

  local obj = vim.system(command_table, {
    text = true,
    detach = true,
  }):wait()

  vim.api.nvim_chan_send(M.term_id, obj.stdout)
  vim.api.nvim_chan_send(M.term_id, obj.stderr)
end

M._resize = function ()
  local lines = vim.api.nvim_buf_get_lines(M.output_buffer, 0, -1, true)
  local width = math.max(util._longest_line(lines), 6)
  local height = vim.api.nvim_buf_line_count(M.output_buffer)

  vim.api.nvim_win_set_config(M.win_id, {
    width = width,
    height = height,
  })
end

M.show = function ()
  vim.cmd('w')

  local file = util._file_name(0)
  local command = util._command_for_file(file, M.patterns)

  M._open_win()
  M._run(command)

  -- this is needed to let the output finish sending to terminal channel if there are issues then change the delay
  local delayMS = 1
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(M.win_id) then
      M._resize()
    end
  end, delayMS)

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

M._clear = function ()
  M.patterns = {}
end

return M
