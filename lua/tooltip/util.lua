local util = {}

util.default_file_patterns = {
  ['.js'] = 'node %s',
  ['.rb'] = 'ruby %s',
  ['.go'] = 'go run %s',
  ['.erl'] = 'escript %s',
  ['.scala'] = 'scala-cli run %s',
  ['.clj'] = 'clojure -M %s',
  ['.lua'] = 'lua %s',
  ['.hs'] = 'runghc %s',
  ['.py'] = 'python3 %s',
  ['.groovy'] = 'groovy %s',
}

util.user_file_patterns = {}

util._merge_tables = function (user_patterns)
  if user_patterns == nil then
    util.user_file_patterns = util.default_file_patterns
    return
  end

  for pattern, command in pairs(util.default_file_patterns) do
    util.user_file_patterns[pattern] = user_patterns[pattern] or command
  end

  for user_pattern, user_command in pairs(user_patterns) do
    util.user_file_patterns[user_pattern] = util.user_file_patterns[user_patterns] or user_command
  end
end

util._table_concat = function (t1,t2)
  local t = {}

  for _, value in ipairs(t1) do
    table.insert(t, value)
  end

  for _, value in ipairs(t2) do
    table.insert(t, value)
  end

  return t
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
  local last_pos = 1

  while last_pos <= #data do

    local start_index, end_index = string.find(data, separator, last_pos)
    local next_word = ''

    if not start_index then
      if last_pos == start_index then
        table.insert(t, next_word)
        break
      end

      next_word = string.sub(data, last_pos, #data)
      table.insert(t, next_word)
      break
    end

    next_word = string.sub(data, last_pos, start_index - 1)
    table.insert(t, next_word)
    last_pos = end_index + 1
  end

  return t
end

util._command_for_file = function (file)
  for file_extension, command in pairs(util.user_file_patterns) do
    if (string.find(file, file_extension) ~= nil) then
      local t = {}

      for str in string.gmatch(string.format(command, file), '([^%s]+)') do
        table.insert(t, str)
      end

      return t
    end
  end

  error('command pattern not set up for this file extension')
end

util._longest_line = function (lines)
  local longest = -1

  for _, line in pairs(lines) do
    longest = math.max(longest, string.len(line))
  end

  return longest
end

return util
