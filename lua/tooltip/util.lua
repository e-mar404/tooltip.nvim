local util = {}

util._file_name = function (output_buffer)
  return vim.api.nvim_buf_get_name(output_buffer)
end

return util
