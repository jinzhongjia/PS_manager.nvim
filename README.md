# 🗄️PS_manager

Auto change pwd in projects, support multiple projects, as vscode workspace.

## Denpendences

- telescope

## Usage

### Config

```lua
require("PS_manager").setup({
-- default config
    datapath = vim.fn.stdpath("data"),
    projects = {
        -- "/home/jin/code/project1",
        -- "/home/jin/code/project2",
    },
})
```

You can edit the project file in `~/.local/share/nvim/PS_manager/project`

### Telescope

```lua
local telescope=require("telescope")
telescope.load_extension("PS_manager") -- this will register a commamd call `Telescope PS_manager`
```

## Todo

These are my ideas about this repository.

- session manager
  > I think session manager should unite with project manager.

## Preview

![preview](https://github.com/jinzhongjia/PS_manager.nvim/blob/main/.img/preview.png)
