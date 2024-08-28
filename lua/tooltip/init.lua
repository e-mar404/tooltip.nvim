local M = {}

local patterns = {}

M.setup = function (config)
  patterns = config['patterns']
end

M._command_for_file = function (file)
  local file_type
  for extension in string.gmatch(file, '%.(%w+)') do
    file_type = string.format('.%s', extension)
    print(file_type)
  end

  local pattern = patterns[file_type]

  if not pattern then
    error('command pattern not set up for this file extension')
  end

  local fmt_string = string.format(patterns[file_type], file)
  print(fmt_string)

  return fmt_string
end

M._run = function (command)
  local output_buffer = tonumber(vim.api.nvim_create_buf(true, true))

  local write_buf = function (_, data)
    if data then
      vim.api.nvim_buf_set_lines(output_buffer, -1, -1, true, data)
    end
  end

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = write_buf,
    on_stderr = write_buf,
  })

  return output_buffer
end

M._open_win = function (output_buffer)
  local opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = 30,
    height = 5,
    anchor = 'NW',
    style = 'minimal',
  }

  -- TODO: find a way to resize window after it opened

  vim.api.nvim_open_win(output_buffer, true, opts)

end

M._file_name = function (output_buffer)
  return vim.api.nvim_buf_get_name(output_buffer)
end

M.show = function ()
  local file = M._file_name(0)
  local command = M._command_for_file(file)
  local output_buffer = M._run(command)

  M._open_win(output_buffer)
end

M._clear = function ()
  patterns = {}
end

return M
