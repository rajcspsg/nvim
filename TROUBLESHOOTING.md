# Troubleshooting Guide

Common issues and their solutions for your Neovim configuration.

## Table of Contents
1. [Debug Adapter Issues](#debug-adapter-issues)
2. [Keybinding Issues](#keybinding-issues)
3. [Treesitter Issues](#treesitter-issues)
4. [LSP Issues](#lsp-issues)
5. [Mason Issues](#mason-issues)
6. [General Issues](#general-issues)

## Debug Adapter Issues

### "No LSP client found that supports vscode.java.startDebugSession"

**Symptoms**: Error when trying to start debugging in Java files

**Cause**: Missing java-debug-adapter or java-test packages

**Solution**:
```bash
# Install missing packages
~/.config/nvim/install-mason-packages.sh

# Or manually
nvim -c ':MasonInstall java-debug-adapter java-test' -c ':q'

# Verify installation
~/.config/nvim/check-install.sh
```

**Verify**:
```bash
ls ~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/*.jar
ls ~/.local/share/nvim/mason/packages/java-test/extension/server/*.jar
```

### Debug session doesn't start

**Check**:
1. Is jdtls running? `:LspInfo`
2. Are bundles loaded? `:lua print(vim.inspect(require('jdtls.dap').test_class))`
3. Check DAP configuration: `:lua print(vim.inspect(require('dap').configurations.java))`

**Solution**:
```vim
" Restart jdtls
:JdtRestart

" Or reload the file
:e
```

### Breakpoints not stopping execution

**Possible causes**:
1. Java file not compiled
2. Debug adapter not properly attached
3. Breakpoint in wrong location (comment, blank line)

**Solutions**:
```bash
# Compile first
javac YourFile.java

# Check DAP logs
nvim
:lua vim.cmd('e ' .. vim.fn.stdpath('cache') .. '/dap.log')
```

## Keybinding Issues

### "Space + d + b" deletes word instead of toggling breakpoint

**Symptoms**: Pressing Space, d, b deletes a word backward

**Cause**: Keybindings not loaded early enough or overridden

**Solution**:
```bash
# Already fixed in lua/keybindings/init.lua:50-53
# Restart Neovim completely
pkill nvim
nvim
```

**Verify**:
```vim
:map <leader>db
" Should show: Toggle Breakpoint
```

### Keybinding doesn't work

**Check what's mapped**:
```vim
:verbose map <leader>db
```

**See all leader+d mappings**:
```vim
:map <leader>d
```

**Test if plugin is loaded**:
```vim
:lua print(vim.inspect(require('persistent-breakpoints')))
```

## Treesitter Issues

### "dap_repl parser not found"

**Symptoms**: Warning message about missing dap_repl parser

**Solution**:
```vim
:TSInstall dap_repl
```

**Or from command line**:
```bash
nvim --headless -c "TSInstall dap_repl" -c "sleep 5" -c "quit"
```

**Verify**:
```bash
ls ~/.local/share/nvim/site/parser/dap_repl.so
```

### Parser compilation failed

**Check build tools**:
```bash
# macOS
xcode-select --install

# Linux (Ubuntu/Debian)
sudo apt install build-essential

# Linux (Fedora/RHEL)
sudo dnf install gcc gcc-c++ make
```

**Reinstall parser**:
```vim
:TSUninstall dap_repl
:TSInstall dap_repl
```

### Syntax highlighting not working

**Update parsers**:
```vim
:TSUpdate
```

**Check parser status**:
```vim
:TSInstallInfo
```

**Check if treesitter is running**:
```vim
:lua print(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
```

## LSP Issues

### jdtls not attaching to Java files

**Check**:
```vim
:LspInfo
```

**Restart jdtls**:
```vim
:LspRestart
```

**Check logs**:
```vim
:LspLog
```

**Verify jdtls is installed**:
```bash
ls ~/.local/share/nvim/mason/packages/jdtls/
```

### "LSP timeout" errors

**Increase timeout**:
```lua
-- In ftplugin/java.lua
vim.lsp.buf_request_sync(0, "method", params, 5000) -- 5 second timeout
```

### Code actions not working

**Check**:
```vim
:lua vim.lsp.buf.code_action()
```

**Verify capability**:
```vim
:lua print(vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities))
```

## Mason Issues

### Package installation failed

**Check logs**:
```vim
:MasonLog
```

**Common issues**:
1. **Network**: Check internet connection
2. **Permissions**: Check directory permissions
3. **Disk space**: Ensure sufficient space

**Retry installation**:
```vim
:MasonUninstall java-debug-adapter
:MasonInstall java-debug-adapter
```

### Mason packages not found

**Verify Mason is installed**:
```bash
ls ~/.local/share/nvim/mason/
```

**Reinstall Mason packages**:
```bash
~/.config/nvim/install-mason-packages.sh
```

### Wrong package version

**Update specific package**:
```vim
:MasonUninstall <package>
:MasonInstall <package>
```

**Update all packages**:
```vim
:MasonUpdate
```

## General Issues

### Neovim startup slow

**Profile startup time**:
```bash
nvim --startuptime startup.log
less startup.log
```

**Common causes**:
1. Too many plugins loading at startup
2. Heavy autocommands
3. Network requests during startup

**Solutions**:
1. Lazy-load plugins with `event`, `ft`, or `cmd`
2. Defer non-critical setup with `vim.schedule()`
3. Use `--noplugin` to test: `nvim --noplugin`

### Plugin conflicts

**Find conflicts**:
```vim
:messages
```

**Load minimal config**:
```bash
nvim --clean
```

**Disable specific plugin**:
```bash
# Rename plugin directory temporarily
mv ~/.local/share/nvim/site/pack/vendor/start/plugin-name{,.bak}
```

### Configuration errors

**Check for errors**:
```vim
:messages
```

**Reload configuration**:
```vim
:source ~/.config/nvim/init.lua
```

**Check specific module**:
```vim
:lua require('plugins.dap-config')
```

### Cache issues

**Clear cache**:
```bash
rm -rf ~/.cache/nvim/
rm -rf ~/.local/state/nvim/
```

**Clear specific cache**:
```bash
rm -rf ~/.cache/nvim/luac/
```

### Persistent-breakpoints not saving

**Check breakpoints file**:
```bash
cat ~/.local/share/nvim/breakpoints.json
```

**Verify plugin loaded**:
```vim
:lua print(require('persistent-breakpoints'))
```

**Check permissions**:
```bash
ls -la ~/.local/share/nvim/
chmod 755 ~/.local/share/nvim/
```

## Diagnostic Commands

### System Check
```bash
~/.config/nvim/check-install.sh
```

### Neovim Health Check
```vim
:checkhealth
```

### LSP Status
```vim
:LspInfo
```

### Mason Status
```vim
:Mason
```

### Treesitter Status
```vim
:TSInstallInfo
```

### DAP Configuration
```vim
:lua print(vim.inspect(require('dap').configurations))
```

### Keymapping Check
```vim
:map <leader>d
```

## Log Locations

### Neovim
```
~/.cache/nvim/log
```

### LSP
```vim
:LspLog
```

### Mason
```bash
~/.local/share/nvim/mason.log
```

### DAP
```bash
~/.cache/nvim/dap.log
```

## Getting Help

1. **Check messages**: `:messages`
2. **Check health**: `:checkhealth`
3. **Check logs**: See "Log Locations" above
4. **Run diagnostic**: `~/.config/nvim/check-install.sh`
5. **Minimal config test**: `nvim --clean`
6. **Check documentation**: `:help <topic>`

## Common Error Messages

### "module not found"
**Solution**: Plugin not installed or wrong path
```vim
:lua package.loaded['module'] = nil
:lua require('module')
```

### "attempt to call nil value"
**Solution**: Function doesn't exist or plugin not loaded
```vim
:lua print(vim.inspect(package.loaded))
```

### "invalid buffer id"
**Solution**: Buffer was deleted or doesn't exist
```vim
:lua print(vim.api.nvim_get_current_buf())
```

## Reset to Fresh State

### Nuclear option (reset everything):
```bash
# Backup first!
cp -r ~/.config/nvim ~/.config/nvim.backup

# Remove all plugins and cache
rm -rf ~/.local/share/nvim/
rm -rf ~/.cache/nvim/
rm -rf ~/.local/state/nvim/

# Reinstall
~/.config/nvim/install-plugins.sh
~/.config/nvim/install-mason-packages.sh
```

## Success Indicators

After fixing issues, you should see:
- ✅ No errors on startup (`:messages`)
- ✅ LSP attached to files (`:LspInfo`)
- ✅ Breakpoints toggle correctly (`Space + d + b`)
- ✅ DAP UI opens when debugging
- ✅ Syntax highlighting works
- ✅ All parsers installed (`:TSInstallInfo`)
- ✅ All Mason packages installed (`:Mason`)

## Still Having Issues?

1. Run full diagnostic:
   ```bash
   ~/.config/nvim/check-install.sh > ~/nvim-diagnostic.txt
   nvim --startuptime ~/nvim-startup.log
   nvim -c ':messages' -c ':w! ~/nvim-messages.txt' -c ':q'
   ```

2. Check all three output files:
   - `~/nvim-diagnostic.txt`
   - `~/nvim-startup.log`
   - `~/nvim-messages.txt`

3. Search for errors or warnings

4. Refer to specific sections above based on the error type
