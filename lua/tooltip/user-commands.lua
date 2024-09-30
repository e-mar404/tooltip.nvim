local util = require('tooltip.util')

vim.api.nvim_create_user_command('TooltipPatterns', function ()
  print(vim.inspect(util.user_file_patterns))
end, {})
