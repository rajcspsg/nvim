# Neovim Configuration

A comprehensive Neovim configuration with LSP, DAP, completion, and more using vim.pack native package management.

## Features

- 🚀 **Native Package Management** - Uses vim.pack (no lazy.nvim, packer, etc.)
- 🔧 **LSP Support** - Full LSP support for 10+ languages via Mason
- 🐛 **Debug Adapter Protocol** - Debugging for Java, Python, JavaScript, Go, Rust, and more
- ✨ **Modern Completion** - blink.cmp with copilot integration
- 🎨 **Syntax Highlighting** - Treesitter-based highlighting
- 📦 **150+ Plugins** - Carefully curated plugin collection
- ⌨️ **Intuitive Keybindings** - Space-based leader key
- 🔍 **Fuzzy Finding** - Telescope integration
- 🌳 **File Explorer** - Neo-tree with diagnostics
- 📊 **Status Line** - Lualine with git integration

## Quick Links

- **[Quick Start Guide](QUICK_START.md)** - Get started in 5 minutes
- **[Installation Guide](INSTALL.md)** - Detailed installation instructions
- **[Keybindings Reference](QUICK_START.md#essential-keybindings)** - All keybindings

## Installation Scripts

| Script | Purpose | Time |
|--------|---------|------|
| `install-plugins.sh` | Install all vim.pack plugins + Mason packages | 5-10 min |
| `install-mason-packages.sh` | Install LSP servers, DAP adapters, formatters | 3-5 min |
| `update-plugins.sh` | Update all plugins and Mason packages | 2-5 min |
| `check-install.sh` | Verify installation status | <1 min |

## Quick Install

```bash
# Install plugins
~/.config/nvim/install-plugins.sh

# Install Mason packages (LSP, DAP, formatters)
~/.config/nvim/install-mason-packages.sh

# Check installation
~/.config/nvim/check-install.sh

# Start Neovim
nvim
```

## What's Installed

### LSP Servers (via Mason)
- Lua (lua-language-server)
- TypeScript/JavaScript (typescript-language-server, vtsls)
- Go (gopls)
- Java (jdtls)
- Python (ruff)
- YAML, Clojure, Dhall, Gradle, Zig

### Debug Adapters (via Mason)
- **Java** - java-debug-adapter, java-test ⭐ (fixed keybinding issue!)
- **Python** - debugpy
- **JavaScript/TypeScript** - js-debug-adapter
- **Go** - delve
- **Rust/C/C++** - codelldb

### Formatters (via Mason)
- prettier
- stylua
- shfmt

### Major Plugins
- **LSP**: nvim-lspconfig, mason.nvim, nvim-jdtls, metals, rustaceanvim
- **Completion**: blink.cmp, LuaSnip, copilot
- **DAP**: nvim-dap, nvim-dap-ui, persistent-breakpoints
- **Treesitter**: nvim-treesitter + extensions
- **Telescope**: telescope.nvim + fzf, undo, hierarchy
- **Git**: neogit, gitsigns, git-blame, git-conflict, diffview
- **UI**: neo-tree, lualine, bufferline, which-key, trouble
- **Testing**: neotest + adapters (Jest, Vitest, Go, Java, Haskell, Playwright)
- **And 120+ more!**

## Essential Keybindings

### Debug (Space + d) ⭐ FIXED!
- `Space d b` - Toggle breakpoint
- `Space d B` - Clear all breakpoints
- `Space d C` - Conditional breakpoint
- `Space d c` - Continue debugging
- `Space d r` - Toggle REPL
- `Space d so` - Step over
- `Space d si` - Step into

### LSP
- `gD` - Go to definition
- `K` - Hover docs
- `gi` - Go to implementation
- `gr` - Go to references
- `Space rn` - Rename
- `Space ca` - Code action

### File Navigation
- `Ctrl e` - Toggle NeoTree
- `Ctrl h/l/j/k` - Window navigation

### Diagnostics (Changed)
- `Space l d` - Buffer diagnostics (moved from `Space d`)
- `Space a a` - All workspace diagnostics
- `[c` / `]c` - Previous/Next diagnostic

## Recent Fixes

### ✅ Fixed: Java Debug Adapter Configuration
- Added Java DAP configuration in `lua/plugins/dap-config/init.lua`
- Supports attach, launch current file, and launch with main class prompt
- Install adapters: `~/.config/nvim/install-mason-packages.sh`

### ✅ Fixed: Space + d + b Keybinding Conflict
- **Problem**: `<leader>d` was mapped to diagnostics, blocking debug keybindings
- **Solution**: Moved diagnostics to `<leader>ld` (Space + l + d)
- **Result**: All debug keybindings now work correctly!

## Troubleshooting

### Java debugging not working?
```bash
# Install debug adapters
~/.config/nvim/install-mason-packages.sh

# Or manually in Neovim
:MasonInstall java-debug-adapter java-test
```

### Check installation status
```bash
~/.config/nvim/check-install.sh
```

### Check for errors in Neovim
```vim
:checkhealth
:messages
:Mason
```

## Project Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── keybindings/init.lua     # All keybindings
│   ├── plugins/
│   │   ├── dap-config/          # Debug adapter config
│   │   ├── lsp-config/          # LSP config
│   │   └── ...                  # Other plugin configs
│   └── rajnvim/bootstrap.lua    # Bootstrap module
├── ftplugin/java.lua            # Java-specific config
├── install-plugins.sh           # Plugin installer
├── install-mason-packages.sh    # Mason package installer
├── update-plugins.sh            # Plugin updater
├── check-install.sh             # Status checker
├── README.md                    # This file
├── INSTALL.md                   # Detailed install guide
└── QUICK_START.md               # Quick reference

~/.local/share/nvim/
├── site/pack/vendor/start/      # Auto-loaded plugins (150+)
└── mason/
    ├── packages/                # Mason packages
    └── share/
        ├── java-debug-adapter/  # Java debug JARs
        └── java-test/           # Java test JARs
```

## Maintenance

### Update Everything
```bash
~/.config/nvim/update-plugins.sh
```

### Check Health
```vim
:checkhealth
```

### View Logs
```vim
:messages       " Neovim messages
:Mason          " Mason status
:MasonLog       " Mason logs
:LspLog         " LSP logs
```

## Requirements

- **Neovim** >= 0.9.0 (0.10+ recommended)
- **Git**
- **Make** (for building plugins)
- **Rust & Cargo** (for blink.cmp)
- **Node.js** (for LSP servers)
- **GCC/Clang** (for telescope-fzf-native)

## Contributing

To add a new plugin:

1. Edit `install-plugins.sh`
2. Add plugin to `plugins` array: `"author/plugin-name"`
3. Run: `~/.config/nvim/install-plugins.sh`

To add a Mason package:

1. Edit `install-mason-packages.sh`
2. Add to appropriate array (LSP, DAP, or formatters)
3. Run: `~/.config/nvim/install-mason-packages.sh`

## License

MIT License (or whatever you prefer)

## Credits

Built with ❤️ using:
- [Neovim](https://neovim.io/)
- [Mason](https://github.com/williamboman/mason.nvim)
- And 150+ amazing open-source plugins!
