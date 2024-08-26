local M = {}

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

  local lines = vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false)

  local opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 80,
    height = #(lines) + 1,
    anchor = "NW",
    style = "minimal",
  }

  vim.api.nvim_open_win(output_buffer, true, opts)
end

return M
