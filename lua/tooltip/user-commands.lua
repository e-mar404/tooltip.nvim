local util = require('tooltip.util')

vim.api.nvim_create_user_command('TooltipPatterns', function ()
  print(vim.inspect(util.user_file_patterns))
end, {})

vim.api.nvim_create_user_command('TooltipAddTempPattern', function (context)
  local file = util._file_name(0)
  local extention = file:match('^.+(%..+)$')
  local command = context.args

  util.user_file_patterns[extention] = command

  P(util.user_file_patterns)
end, { nargs=1, })
