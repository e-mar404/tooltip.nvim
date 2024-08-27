# tooltip.nvim

tooltip to display output of files

Note: since it uses lua Neovim >= 0.5 is required

## Demo
https://github.com/user-attachments/assets/b9b9ca0f-b1b8-4e0f-a9fa-e14e464deda1


## Installation

Packer:

``` lua
use "e-mar404/tooltip"
```

## Setup

There are 2 parts that will need to be configured for each language:
1. getting the file that will be executed
2. call run function that will execute said file and put all stdout (or stderr) into a floating window where the cursor is

To set up a language the file extention and the command to execute will have to be added to the patterns opt through the setuup function. See bellow for the pattern and keymap examples of javascript and ruby.
Ex. 

``` lua
local tooltip = require("tooltip")

tooltip.setup({
  patterns = {
    [".js"] = "node %s",
    [".rb"] = "ruby %s",
    -- ["file extenstion"] = "command to execute" (%s) will be replaced by the file path
  },
})

-- universal-tooltip keymap (run program)
vim.keymap.set('n', '<leader>rp', function ()
    tooltip.show()
end)
```
