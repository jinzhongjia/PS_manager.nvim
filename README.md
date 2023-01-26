Auto change pwd in projects, support multiple porjects, as vscode workspace

## denpendences

- telescope

## usage

```lua
require("PS_manager").setup({
    projects = {
        "/home/jin/code/project1",
        "/home/jin/code/project2",
    },
})
```

telescope

```lua
local telescope=require("telescope")
telescope.load_extension("PS_manager")
```
