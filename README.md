# tooltip.nvim

tooltip to display output of files

Note: since it uses lua Neovim >= 0.5 is required

## Demo

https://github.com/user-attachments/assets/48294cba-a14b-44f7-bad9-750294b83a73



## Installation

Packer:

``` lua
use 'e-mar404/tooltip'
```

## Documentation

See `:help tooltip.nvim`

## Setup

Only set up that is needed is to set up a keymap to show the tooltip. There is an optional step to set up your own custom commands for a file pattern or if you want a command for a file that is not set up by default. 

To set up file patterns it is passed as a table attribute to the `setup()`. See bellow for example:

Ex. 
``` lua
local tooltip = require('tooltip')

tooltip.setup {
  patterns = {
    ['.js'] = 'node %s',
    ['.rb'] = 'ruby %s',
    ['.go'] = 'go run %s',
    -- ['file extenstion'] = 'command_to_execute %s' (%s) will be replaced by the file path
    -- what is set up here will override the default mappings if there is already a command set up for that file pattern
  },
}

-- universal-tooltip keymap (run program)
vim.keymap.set('n', '<leader><leader>r', function ()
    tooltip.show()
end)
```

### Default File-Command Mappings

This plugin comes with default mappings so there is as little set up as possible. If you do find your self needing to override the command that gets executed with each file pattern then you can set your custom command, shown above. 

|File pattern|Command         |
|------------|----------------|
|'.js'       |'node %s'       |
|'.rb'       |'ruby %s'       |
|'.go'       |'go run %s'     |
|'.erl'      |'escript %s'    |
|'.scala'    |'scala %s'      |
|'.clj'      | 'clojure -M %s'|
|'.lua'      |'lua %s'        |

