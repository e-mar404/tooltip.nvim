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
|'.scala'    |'scala-cli %s'  |
|'.clj'      |'clojure -M %s' |
|'.lua'      |'lua %s'        |
|'.groovy'   |'groovy %s'     |


## Opportunity to extend the plugin

I have 2 ideas on how to extend/refactor this plug in: 

1. instead of using file extensions it might be little cleaner to use file types
   so it is more expressive and instead of saying `.js = node %s` it can be
   `javascript = node %s`. It might be easier to use file extensions since I
   always know what the file extension is but i might not know the file type.
   Idk i'll see but for now i like file type better.

2. support multiple file commands to run and whenever there are multiple
   commands list them out to choose before running. This would need the set up
   file to have an some type of 'override_default' flag to see if the command
   being set up should be treated as the new default of it is just a command
   being added

3. once there is support for multiple file commands it is possible to have a dot
    file in the current directory that specifies how to run a file and
    if there are multiple file commands for each file type then show a list of
    the commands to run and select one to run.
    
    - example having the option to run one of the following
    
    - '.go' = run ./run/some/predetermined/path
    - '.go' = run main.go
    - '.go' = run .
    - wtv is the default for that file extension if there is one
