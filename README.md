# tooltip.nvim

tooltip to display output of files

Note: since it uses lua Neovim >= 0.5 is required

## Demo
https://github.com/user-attachments/assets/b9b9ca0f-b1b8-4e0f-a9fa-e14e464deda1


## Installation

Packer:

``` lua
use 'e-mar404/tooltip'
```

## Documentation

See `:help tooltip.nvim`

## Setup

There are 2 parts that will need to be configured before using the plugin:
1. Set up a pattern for the command that will execute each file extension
2. call the `show()` function that will take the current file, see if there is a pattern set up for it and then execute it. After execution the stdout (or stderr) will be outputed in a new floating window where the cursor is at.

Ex. 
``` lua
local tooltip = require('tooltip')

tooltip.setup({
  patterns = {
    ['.js'] = 'node %s',
    ['.rb'] = 'ruby %s',
    -- ['file extenstion'] = 'command_to_execute %s' (%s) will be replaced by the file path
  },
})

-- universal-tooltip keymap (run program)
vim.keymap.set('n', '<leader>rp', function ()
    tooltip.show()
end)
```
