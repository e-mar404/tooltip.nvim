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
  local output_buffer = vim.api.nvim_create_buf(false, true)

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

  return tonumber(output_buffer)
end

M.open_win = function (output_buffer)
  local num_lines = tonumber(vim.fn.system({ "wc", "-l", vim.fn.expand("%") }):match("%d+"))

  local opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 30,
    height = num_lines + 1,
    anchor = "NW",
    style = "minimal",
  }

  vim.api.nvim_open_win(output_buffer, true, opts)
end

M.file_name = function ()
  return vim.api.nvim_buf_get_name(0)
end

M.show = function ()
  local file = M.file_name()
  local command = M.command_from_file(file)
  local output_buffer = M.run(command)

  M.open_win(output_buffer)
end

return M
