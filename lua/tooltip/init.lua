local M = {}

local patterns = {}

M.setup = function (opts)
  patterns = opts["patterns"]
end

M.command_from_file = function (file)
  local delimeter_pos = string.find(file, "%.") or -1

  local file_type = string.sub(file, delimeter_pos)

  local fmt_string = string.format(patterns[file_type], file)
  print(fmt_string)

  return fmt_string
end

M.run = function (command)
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

M.open_win = function (output_buffer)
  local opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 30,
    height = 5,
    anchor = "NW",
    style = "minimal",
  }

  -- TODO: find a way to resize window after it opened

  vim.api.nvim_open_win(output_buffer, true, opts)

end

M.resize = function ()
  local win_id = vim.api.nvim_get_current_win()
  local num_lines = vim.api.nvim_buf_line_count(0)

  vim.api.nvim_win_set_height(win_id, num_lines)
end

M.file_name = function (output_buffer)
  return vim.api.nvim_buf_get_name(output_buffer)
end

M.show = function ()
  local file = M.file_name(0)
  local command = M.command_from_file(file)
  local output_buffer = M.run(command)

  M.open_win(output_buffer)
end

return M
