# Java Debugging Setup Guide

This guide covers the complete setup and usage of Java debugging in Neovim.

## ✅ What's Been Fixed

### 1. Keybinding Conflict Resolution
- **Problem**: `Space + d + b` was executing "delete word backward" instead of toggling breakpoint
- **Cause**: Keybindings were defined in lazy.nvim-style `keys` table, which doesn't work with vim.pack
- **Solution**: Added keybindings directly in `lua/keybindings/init.lua:50-53`

### 2. Java Debug Adapter Installation
- **Problem**: Missing java-debug-adapter and java-test packages
- **Solution**: Installed via Mason and updated paths in `ftplugin/java.lua`

### 3. Correct JAR Paths
- **Problem**: Paths pointed to non-existent directories
- **Solution**: Updated to use Mason's actual package structure:
  - Debug: `~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/*.jar`
  - Test: `~/.local/share/nvim/mason/packages/java-test/extension/server/*.jar`

## Installation Status

Run this command to verify everything is installed:

```bash
~/.config/nvim/check-install.sh
```

You should see:
- ✅ java-debug-adapter JAR found
- ✅ java-test JARs found: 29
- ✅ All configuration files present

## Debug Keybindings

All keybindings use `Space` as the leader key:

| Keybinding | Action | Plugin |
|------------|--------|--------|
| `Space d b` | Toggle breakpoint | persistent-breakpoints |
| `Space d B` | Clear all breakpoints | persistent-breakpoints |
| `Space d C` | Conditional breakpoint | persistent-breakpoints |
| `Space d t` | Toggle breakpoint (basic) | nvim-dap |
| `Space d c` | Continue/Start debugging | nvim-dap |
| `Space d r` | Toggle REPL | nvim-dap |
| `Space d so` | Step over | nvim-dap |
| `Space d si` | Step into | nvim-dap |
| `Space d l` | Run last | nvim-dap |
| `Space d K` | Hover (inspect variable) | nvim-dap |

## Quick Start: Debug a Java File

### 1. Open a Java file
```bash
nvim /tmp/TestJavaDebug.java
```

### 2. Set a breakpoint
- Move cursor to the line where you want to break
- Press: `Space` + `d` + `b`
- You should see a blue circle (🔵) in the sign column

### 3. Start debugging
Press: `Space` + `d` + `c`

This will:
1. Prompt you to select a debug configuration
2. Start the Java debug session
3. Stop at your breakpoint

### 4. Debug controls
Once stopped at a breakpoint:
- `Space d so` - Step over (execute current line)
- `Space d si` - Step into (enter function)
- `Space d K` - Hover to inspect variable values
- `Space d c` - Continue to next breakpoint

### 5. Stop debugging
- Press `Space d c` repeatedly to continue to the end
- Or close the DAP UI windows

## Example Test File

Create this file to test debugging:

```java
// File: /tmp/TestJavaDebug.java
public class TestJavaDebug {
    public static void main(String[] args) {
        System.out.println("Hello, Debug!");
        int x = 10;           // <- Set breakpoint here (Space d b)
        int y = 20;
        int sum = x + y;
        System.out.println("Sum: " + sum);
    }
}
```

## Debug Configurations

When you press `Space + d + c`, you'll be prompted to select a configuration:

1. **Debug (Attach) - Remote**
   - Attach to a running Java process on port 5005
   - Use when you've started Java with debug flags

2. **Debug (Launch) - Current File**
   - Debug the current Java file
   - Best for simple single-file programs

3. **Debug (Launch) - Main Class**
   - Prompts for the main class to debug
   - Use for multi-file projects

## Breakpoint Types

### Regular Breakpoint
```
Space + d + b
```
Stops execution every time this line is reached.

### Conditional Breakpoint
```
Space + d + C
```
Prompts for a condition (e.g., `x > 10`). Only breaks when condition is true.

### Clear All Breakpoints
```
Space + d + B
```
Removes all breakpoints from all files.

## Persistent Breakpoints

Your breakpoints are automatically saved and restored across sessions!

Files: `~/.local/share/nvim/breakpoints.json`

## DAP UI

When debugging starts, the DAP UI automatically opens with:

**Left Panel:**
- Scopes (local variables)
- Breakpoints list
- Watches

**Bottom Panel:**
- REPL (evaluate expressions)
- Console (program output)

## Troubleshooting

### "No LSP client found that supports vscode.java.startDebugSession"

**Problem**: Java debug adapters not installed

**Solution**:
```bash
~/.config/nvim/install-mason-packages.sh
# OR
nvim -c ':MasonInstall java-debug-adapter java-test' -c ':q'
```

### Breakpoint not stopping

**Symptoms**: Blue circle shows but debugger doesn't stop

**Solutions**:
1. Compile your Java file first: `javac YourFile.java`
2. Check if jdtls is running: `:LspInfo`
3. Check DAP logs: `:lua vim.cmd('e ' .. vim.fn.stdpath('cache') .. '/dap.log')`

### "Space + d + b" still deleting word

**Solution**: Restart Neovim completely
```bash
# Exit all nvim instances, then:
nvim
```

### Can't start debug session

**Check**:
1. Is jdtls running? `:LspInfo` (should show jdtls attached)
2. Are debug adapters loaded? `:lua print(vim.inspect(require('jdtls').setup_dap()))`
3. Check for errors: `:messages`

### Debug UI not appearing

**Solution**: Manually toggle DAP UI
```vim
:lua require('dapui').toggle()
```

## File Locations

### Configuration Files
```
~/.config/nvim/
├── ftplugin/java.lua              # Java LSP + DAP setup
├── lua/
│   ├── keybindings/init.lua       # Debug keybindings (lines 50-53)
│   └── plugins/
│       └── dap-config/init.lua    # DAP configuration (lines 116-134, 392-414)
```

### Debug Adapters
```
~/.local/share/nvim/mason/packages/
├── java-debug-adapter/
│   └── extension/server/
│       └── com.microsoft.java.debug.plugin-0.53.2.jar
└── java-test/
    └── extension/server/
        └── *.jar (29 files)
```

### Breakpoints
```
~/.local/share/nvim/breakpoints.json
```

## Advanced Usage

### Attach to Remote JVM

1. Start your Java app with debug flags:
```bash
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 YourApp
```

2. In Neovim, press `Space d c` and select "Debug (Attach) - Remote"

### Debug with Arguments

Edit `lua/plugins/dap-config/init.lua` and add a configuration:

```lua
{
  type = "java",
  request = "launch",
  name = "Debug with Args",
  mainClass = "com.example.Main",
  args = {"arg1", "arg2"},
}
```

### Custom JVM Options

Add to your debug configuration:

```lua
{
  type = "java",
  request = "launch",
  name = "Debug with JVM Options",
  mainClass = "com.example.Main",
  vmArgs = "-Xmx512m -Dmy.property=value",
}
```

## Resources

- **nvim-dap docs**: `:help dap.txt`
- **nvim-jdtls docs**: `:help nvim-jdtls`
- **persistent-breakpoints**: `:help persistent-breakpoints.nvim`
- **Check logs**: `:messages`, `:LspLog`, `:MasonLog`

## Quick Reference Card

```
╔════════════════════════════════════════════════════════╗
║           Java Debugging Quick Reference               ║
╠════════════════════════════════════════════════════════╣
║ Toggle Breakpoint        │  Space + d + b              ║
║ Start/Continue Debug     │  Space + d + c              ║
║ Step Over                │  Space + d + so             ║
║ Step Into                │  Space + d + si             ║
║ Inspect Variable         │  Space + d + K              ║
║ Clear All Breakpoints    │  Space + d + B              ║
║ Conditional Breakpoint   │  Space + d + C              ║
╠════════════════════════════════════════════════════════╣
║ LSP Info                 │  :LspInfo                   ║
║ Mason Packages           │  :Mason                     ║
║ Check Installation       │  :!check-install.sh         ║
╚════════════════════════════════════════════════════════╝
```

## Success Checklist

- [ ] java-debug-adapter installed (`:Mason`)
- [ ] java-test installed (`:Mason`)
- [ ] jdtls LSP running (`:LspInfo`)
- [ ] Keybinding works (`Space d b` shows blue circle)
- [ ] Can start debug session (`Space d c`)
- [ ] Can step through code (`Space d so`)
- [ ] Can inspect variables (`Space d K`)

If all checkboxes are checked, you're ready to debug! 🎉
