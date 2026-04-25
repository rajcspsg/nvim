# vim.pack Quick Reference

## 💡 How vim.pack Works

**TL;DR:** Put plugins in `~/.local/share/nvim/site/pack/vendor/start/` and they **automatically load**. No code needed!

### The Magic

Neovim's native package system works by **directory structure alone**:

```
~/.local/share/nvim/site/pack/*/start/*  ← Neovim scans this at startup
```

When Neovim starts:
1. 🔍 Scans all directories in `pack/*/start/*`
2. ➕ Adds each plugin to `runtimepath`
3. 📄 Auto-sources `plugin/*.vim` and `plugin/*.lua`
4. ✅ Makes `lua/` modules available

**Result:** All plugins just work, no `require()` or `:packadd` needed!

### No Plugin Manager Code Required

❌ **DON'T need:**
```lua
require("lazy").setup()        -- lazy.nvim
require("packer").startup()    -- packer.nvim
call plug#begin()              -- vim-plug
```

✅ **Just use:**
```bash
# Clone to start/ directory
git clone https://github.com/owner/plugin.git \
  ~/.local/share/nvim/site/pack/vendor/start/plugin
```

That's it! Plugin auto-loads on next Neovim start.

---

## 🎯 Common Commands

### Install All Plugins (Fresh Install)
```bash
~/.config/nvim/install-plugins.sh
```
Use this when:
- You deleted `~/.local/share/nvim`
- Setting up on a new machine
- Need to reinstall everything from scratch

### Update All Plugins
```bash
~/.config/nvim/update-plugins.sh
```
Use this to keep plugins up to date (runs `git pull` on each)

### Add a New Plugin
```bash
cd ~/.local/share/nvim/site/pack/vendor/start
git clone --depth=1 https://github.com/owner/plugin.git
```

### Remove a Plugin
```bash
rm -rf ~/.local/share/nvim/site/pack/vendor/start/plugin-name
```

### Update Single Plugin
```bash
cd ~/.local/share/nvim/site/pack/vendor/start/plugin-name
git pull
```

## 📁 Key Locations

| Purpose | Path |
|---------|------|
| Plugins (auto-loaded) | `~/.local/share/nvim/site/pack/vendor/start/` |
| Optional plugins | `~/.local/share/nvim/site/pack/vendor/opt/` |
| Neovim config | `~/.config/nvim/` |
| Backup config | `~/.config/nvim/init.lua.lazy.backup` |

## 🔧 Plugin Counts

- **126 plugins** in `start/` (auto-loaded)
- **1 plugin** in `opt/` (playground - load with `:packadd playground`)

## 🏗️ Plugins Requiring Build Steps

After installing or updating, these plugins may need rebuilding:

```bash
# telescope-fzf-native
cd ~/.local/share/nvim/site/pack/vendor/start/telescope-fzf-native.nvim
make

# LuaSnip
cd ~/.local/share/nvim/site/pack/vendor/start/LuaSnip
make install_jsregexp

# blink.cmp (requires Rust)
cd ~/.local/share/nvim/site/pack/vendor/start/blink.cmp
cargo build --release
```

## 🆘 Troubleshooting

### Neovim won't start
```bash
# Check for errors
nvim --headless "+lua print('test')" +qa
```

### Plugin not loading
```bash
# Verify plugin exists
ls ~/.local/share/nvim/site/pack/vendor/start/
```

### Reset everything
```bash
# Remove all plugins
rm -rf ~/.local/share/nvim

# Reinstall from scratch
~/.config/nvim/install-plugins.sh
```

### Restore lazy.nvim
```bash
cd ~/.config/nvim
mv init.lua init.lua.vimpack
mv init.lua.lazy.backup init.lua
```

## 📚 Vim Help

```vim
:help packages          " Learn about vim packages
:packadd plugin-name   " Load optional plugin
:helptags ALL          " Rebuild help tags
```

## 🔄 Workflow Summary

**Daily use:**
- Just use Neovim normally
- All 126 plugins auto-load

**Weekly/Monthly:**
```bash
~/.config/nvim/update-plugins.sh
```

**After deleting ~/.local/share/nvim:**
```bash
~/.config/nvim/install-plugins.sh
```

## 📦 Your Plugin List

Complete list in: `MIGRATION_GUIDE.md`

Key plugins:
- **LSP**: nvim-lspconfig, mason.nvim, blink.cmp
- **Fuzzy finder**: telescope.nvim + extensions
- **Treesitter**: nvim-treesitter + modules
- **Git**: neogit, gitsigns, diffview, git-conflict
- **DAP**: nvim-dap + language adapters
- **Testing**: neotest + language adapters
- **Languages**: Clojure, Haskell, Rust, Go, TypeScript, Scala, Java, Zig, Nix, Python
