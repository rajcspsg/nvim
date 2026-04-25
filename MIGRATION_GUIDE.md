# Migration from lazy.nvim to vim.pack

This Neovim configuration has been migrated from lazy.nvim to Vim's native package management system (vim.pack).

## What Changed

### Before (lazy.nvim)
- Plugins managed by lazy.nvim package manager
- Plugins stored in: `~/.local/share/nvim/lazy/`
- Plugin specs defined with lazy.nvim DSL
- Automatic lazy-loading and dependency resolution
- UI for plugin management (`:Lazy`)

### After (vim.pack)
- Plugins managed by Vim's native package system
- Plugins stored in: `~/.local/share/nvim/site/pack/vendor/start/`
- Direct plugin setup in Lua configs
- All plugins loaded at startup (no lazy-loading)
- Manual plugin management via git

## How vim.pack Works (No Code Required!)

Vim's native package management works **automatically** based on directory structure alone. You don't need to call any functions or commands.

### Automatic Plugin Loading

When Neovim starts, it automatically:
1. Scans `~/.local/share/nvim/site/pack/*/start/*` directories
2. Adds each plugin directory to the `runtimepath`
3. Sources all `plugin/*.vim` and `plugin/*.lua` files
4. Makes `lua/` modules available to `require()`

**No explicit loading needed!** Just put plugins in the `start/` directory and they work.

### Example:

```
~/.local/share/nvim/site/pack/vendor/start/telescope.nvim/
                                         ├── plugin/telescope.vim  ← Auto-sourced!
                                         └── lua/telescope/...      ← Auto-available!
```

Result: `require('telescope')` just works, no setup code needed!

### Runtime Path Proof

Neovim automatically includes in `runtimepath`:
```
~/.local/share/nvim/site/pack/*/start/*
```

You can verify with: `:set runtimepath?`

### Comparison:

| Method | How It Works |
|--------|--------------|
| **lazy.nvim** | `require("lazy").setup()` explicitly loads plugins |
| **vim.pack** | Directory structure → automatic loading |
| **packer.nvim** | `require('packer').startup()` explicitly loads |
| **vim-plug** | `call plug#begin()` explicitly loads |

**vim.pack = Built into Neovim core!**

### When to Use `:packadd`

Only for **optional** plugins in the `opt/` directory:
```lua
vim.cmd('packadd playground')  -- Manually load when needed
```

For `start/` plugins? **Nothing needed!** They auto-load.

## Directory Structure

```
~/.local/share/nvim/site/pack/vendor/
├── start/          # Auto-loaded plugins (126 plugins)
│   ├── plenary.nvim/
│   ├── telescope.nvim/
│   ├── blink.cmp/
│   └── ...
└── opt/            # Optional plugins (loaded with :packadd)
    └── playground/
```

## Installed Plugins (126 total)

All 126 plugins from your lazy.nvim setup have been cloned to the `start/` directory.

### Plugins with Special Build Steps

The following plugins required compilation and have been built:

1. **telescope-fzf-native.nvim** - Built with `make`
2. **blink.cmp** - Built with `cargo build --release`
3. **LuaSnip** - Built jsregexp with `make install_jsregexp`

### Key Dependencies

- **blink.lib** - Required dependency for blink.cmp v2 (added during migration)

## Managing Plugins

### Adding a New Plugin

```bash
cd ~/.local/share/nvim/site/pack/vendor/start
git clone --depth=1 https://github.com/owner/plugin.git plugin-name
```

### Updating Plugins

```bash
# Update all plugins
cd ~/.local/share/nvim/site/pack/vendor/start
for dir in */; do
  echo "Updating $dir..."
  git -C "$dir" pull
done
```

### Update a single plugin

```bash
cd ~/.local/share/nvim/site/pack/vendor/start/plugin-name
git pull
```

### Removing a Plugin

```bash
rm -rf ~/.local/share/nvim/site/pack/vendor/start/plugin-name
```

### Optional Plugins (lazy-loaded)

To use optional plugins:

```bash
# Move to opt directory
mv ~/.local/share/nvim/site/pack/vendor/start/plugin-name \
   ~/.local/share/nvim/site/pack/vendor/opt/

# Load in Neovim when needed
:packadd plugin-name
```

## Configuration Changes

### init.lua

The main changes to `init.lua`:

1. **Removed** lazy.nvim bootstrap code
2. **Added** native plugin disabling via `vim.g.loaded_*`
3. **Changed** plugin configs now called directly instead of lazy specs

### Plugin Configs

Plugin configuration files no longer return lazy.nvim specs. They now:

1. Call `require("plugin").setup()` directly
2. Set up keymaps directly with `vim.keymap.set()`
3. Run any initialization code immediately

Example conversion:

**Before (lazy.nvim):**
```lua
return {
  "plugin/name",
  config = function()
    require("plugin").setup({ ... })
  end,
}
```

**After (vim.pack):**
```lua
require("plugin").setup({ ... })
```

## Backup

Your original lazy.nvim configuration has been backed up:

- `~/.config/nvim/init.lua.lazy.backup` - Original init.lua

To restore the lazy.nvim setup:

```bash
cd ~/.config/nvim
mv init.lua init.lua.vimpack
mv init.lua.lazy.backup init.lua
```

## Helper Scripts

### Plugin Install Script

If you delete `~/.local/share/nvim` or need to install from scratch:

```bash
~/.config/nvim/install-plugins.sh
```

This will:
- Create the pack directory structure
- Clone all 126 plugins
- Build plugins that require compilation
- Move playground to opt directory

### Plugin Update Script

To update existing plugins:

```bash
#!/bin/bash
PACK_DIR="$HOME/.local/share/nvim/site/pack/vendor/start"

cd "$PACK_DIR" || exit 1
echo "Updating plugins in $PACK_DIR..."

for dir in */; do
  echo "Updating ${dir%/}..."
  if git -C "$dir" pull 2>&1 | grep -q "Already up to date"; then
    echo "  ✓ Already up to date"
  else
    echo "  → Updated!"
  fi
done

echo ""
echo "Rebuilding plugins with build steps..."

# telescope-fzf-native
cd "$PACK_DIR/telescope-fzf-native.nvim" && make

# blink.cmp (if you want to rebuild)
# cd "$PACK_DIR/blink.cmp" && cargo build --release

echo ""
echo "All plugins updated!"
```

Make it executable:
```bash
chmod +x ~/.config/nvim/update-plugins.sh
```

## Performance Notes

- **Startup may be slower** - All plugins load at startup (no lazy-loading)
- **Memory usage** - All plugins loaded into memory immediately
- Current plugin count: 126 plugins in `start/`

To improve performance, consider:
1. Moving rarely-used plugins to `opt/` directory
2. Removing plugins you don't use
3. Loading some plugins conditionally in your config

## Troubleshooting

### Plugin Not Working

1. Check if plugin exists:
   ```bash
   ls ~/.local/share/nvim/site/pack/vendor/start/
   ```

2. Check if plugin needs building:
   ```bash
   # Look for Makefile, Cargo.toml, etc.
   cd ~/.local/share/nvim/site/pack/vendor/start/plugin-name
   ls -la
   ```

3. Check for errors:
   ```bash
   nvim --headless "+lua print('Test')" +qa
   ```

### Plugin Config Errors

If a plugin config file has errors, it will be caught by the `pcall()` wrapper in `init.lua` and an error message will be displayed.

To debug:
```lua
-- In init.lua, temporarily change:
local status_ok, fault = pcall(require, config)
-- to:
require(config)  -- This will show the full error
```

## Notes

- **No automatic updates** - You must manually update plugins
- **No dependency resolution** - You must ensure dependencies are installed
- **No version pinning** - All plugins are on latest commit (depth=1 clone)
- **playground** plugin moved to `opt/` due to compatibility issues

## Resources

- Vim packages help: `:help packages`
- Your plugin directory: `~/.local/share/nvim/site/pack/vendor/start/`
- Original lazy.nvim backup: `~/.config/nvim/init.lua.lazy.backup`
