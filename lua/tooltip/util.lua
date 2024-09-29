local util = {}

util.default_file_patterns = {
  ['.js'] = 'node %s',
  ['.rb'] = 'ruby %s',
  ['.go'] = 'go run %s',
  ['.erl'] = 'escript %s',
  ['.scala'] = 'scala %s',
  ['.clj'] = 'clojure -M %s',
  ['.lua'] = 'lua %s',
  ['.hs'] = 'runghc %s',
}

util._override_file_patterns = function (patterns)
  for pattern, command in pairs(patterns) do
    util.default_file_patterns[pattern] = command
  end
end

util._file_name = function (output_buffer)
  return vim.api.nvim_buf_get_name(output_buffer)
end

util._table_of = function (data, separator)
  if data == '' then
    return { '' }
  end

  separator = separator or '%s'

  local t = {}

  for str in string.gmatch(data, '([^'..separator..']+)') do
    table.insert(t, str)
  end

  return t
end

util._trim_trailing_newline = function (str)
  return str:gsub('\n$', '')
end

util._command_for_file = function (file, patterns)
  local file_type
  for extension in string.gmatch(file, '%.(%w+)') do
    file_type = string.format('.%s', extension)
  end

  local pattern = patterns[file_type]

  if not pattern then
    error('command pattern not set up for this file extension')
  end

  local fmt_string = string.format(patterns[file_type], file)
  print(fmt_string)

  return fmt_string
end

util._longest_line = function (lines)
  local longest = -1

  for _, line in pairs(lines) do
    longest = math.max(longest, string.len(line))
  end

  return longest
end

return util
