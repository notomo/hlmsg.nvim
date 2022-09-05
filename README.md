This is an experimental plugin to open highlighted message history buffer.

```lua
vim.cmd.tabedit()
vim.bo.buftype = "nofile"
require("hlmsg").render(0)
```
