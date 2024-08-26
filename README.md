# em-tooltip.nvim

tooltip to display output of files

Note: since it uses lua Neovim >= .7 is required

## Installation

Packer:

```
use "e-mar404/tooltip"
```

## Setup

There are 2 parts that will need to be configured for each language:
1. getting the file that will be executed
2. call run function that will execute said file and put all stdout (or stderr) into a floating window where the cursor is

I have keymaps set up for each language (prob will add a function to figure out the file and run command depending on file extension and it can just be one universal keymap)

Ex. 

lua
``` 
local tooltip = require("

-- js-tooltip
vim.keymap.set("n", "<leader>js", function()
    local file = tooltip.file_name()

    tooltip.run({ "node", file })
end)

-- ruby-tooltip
vim.keymap.set("n", "<leader>rb", function()
    local file = tooltip.file_name()

    tooltip.run({ "ruby", file })
end)
```
