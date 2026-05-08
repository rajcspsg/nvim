# Neovim Configuration Installation Guide

This guide covers installing and maintaining your Neovim configuration with vim.pack and Mason.

## Prerequisites

- **Neovim** >= 0.9.0 (recommended: 0.10+)
- **Git**
- **Make** (for building some plugins)
- **Rust & Cargo** (for blink.cmp)
- **Node.js** (for some LSP servers)
- **GCC/Clang** (for telescope-fzf-native)

## Quick Start

### 1. Fresh Installation

```bash
# Clone this config (if not already done)
git clone <your-repo> ~/.config/nvim

# Run the installation script
~/.config/nvim/install-plugins.sh

# Install Mason packages (LSP, DAP, formatters)
~/.config/nvim/install-mason-packages.sh

# Start Neovim
nvim
```

### 2. Update Existing Installation

```bash
# Update all plugins
~/.config/nvim/update-plugins.sh
```

## Installation Scripts

### `install-plugins.sh`
Installs all vim.pack plugins from GitHub.

**What it does:**
- Creates pack directory structure (`~/.local/share/nvim/site/pack/vendor/start`)
- Clones 147+ plugins from GitHub
- Builds plugins that require compilation:
  - `telescope-fzf-native.nvim` (C)
  - `LuaSnip` (jsregexp)
  - `blink.cmp` (Rust - takes 2-3 minutes)
- Installs Mason packages (LSP servers, DAP adapters, formatters)

**Usage:**
```bash
~/.config/nvim/install-plugins.sh
```

**Expected time:** 5-10 minutes (depending on connection speed)

### `install-mason-packages.sh`
Installs Mason packages specifically (can be run separately).

**Packages installed:**

**LSP Servers:**
- lua-language-server
- typescript-language-server
- vtsls
- gopls
- jdtls (Java)
- yaml-language-server
- clojure-lsp
- dhall-lsp
- gradle-language-server
- zls (Zig)
- ruff (Python)

**Debug Adapters:**
- java-debug-adapter ⭐ (required for Java debugging)
- java-test ⭐ (required for Java test debugging)
- debugpy (Python)
- js-debug-adapter (JavaScript/TypeScript)
- codelldb (Rust, C, C++)
- delve (Go)

**Formatters:**
- prettier
- stylua
- shfmt

**Usage:**
```bash
~/.config/nvim/install-mason-packages.sh
```

**Check installation status:**
```vim
:Mason
```

### `update-plugins.sh`
Updates all installed plugins and Mason packages.

**What it does:**
- Pulls latest changes for all plugins
- Rebuilds plugins that need compilation
- Updates all Mason packages via `:MasonUpdate`

**Usage:**
```bash
~/.config/nvim/update-plugins.sh
```

**Recommended frequency:** Weekly or monthly

## Manual Installation (Alternative)

If the scripts fail or you want more control:

### 1. Install Plugins Manually

```bash
# Create directory
mkdir -p ~/.local/share/nvim/site/pack/vendor/start
cd ~/.local/share/nvim/site/pack/vendor/start

# Clone a plugin (example)
git clone --depth=1 https://github.com/nvim-lua/plenary.nvim.git

# Build plugins that need compilation
cd telescope-fzf-native.nvim && make
cd LuaSnip && make install_jsregexp
cd blink.cmp && cargo build --release
```

### 2. Install Mason Packages Manually

Start Neovim and run:

```vim
" Install LSP servers
:MasonInstall lua-language-server typescript-language-server gopls

" Install debug adapters (required for debugging)
:MasonInstall java-debug-adapter java-test debugpy js-debug-adapter

" Install formatters
:MasonInstall prettier stylua shfmt
```

## Verifying Installation

### Check Plugin Installation
```bash
ls ~/.local/share/nvim/site/pack/vendor/start/
```

Should show 147+ directories.

### Check Mason Packages
```vim
:Mason
```

Should show all LSP servers, DAP adapters, and formatters installed.

### Check Java Debug Adapter
```bash
ls ~/.local/share/nvim/mason/share/java-debug-adapter/
ls ~/.local/share/nvim/mason/share/java-test/
```

These directories should exist and contain JAR files.

## Troubleshooting

### "No LSP client found" for Java
**Solution:** Install java-debug-adapter and java-test
```bash
~/.config/nvim/install-mason-packages.sh
# OR in Neovim:
:MasonInstall java-debug-adapter java-test
```

### Breakpoint keybinding not working (Space + d + b)
**Solution:** Already fixed in `lua/keybindings/init.lua`
- Removed conflict with `<leader>d` (diagnostics)
- Diagnostics moved to `<leader>ld`

### blink.cmp not working
**Solution:** Build with Rust
```bash
cd ~/.local/share/nvim/site/pack/vendor/start/blink.cmp
cargo build --release
```

### telescope-fzf-native not working
**Solution:** Build with make
```bash
cd ~/.local/share/nvim/site/pack/vendor/start/telescope-fzf-native.nvim
make
```

### Plugin not loading
**Solution:** Check for errors
```vim
:messages
```

### Mason package failed to install
**Solution:** Try manual installation
```vim
:MasonLog
:MasonInstall <package-name>
```

## Directory Structure

```
~/.config/nvim/
├── init.lua                      # Main config entry point
├── lua/
│   ├── keybindings/
│   │   └── init.lua             # Keybindings (Space + d + b, etc.)
│   ├── plugins/
│   │   ├── dap-config/
│   │   │   └── init.lua         # Debug adapter config (Java, Python, JS, etc.)
│   │   ├── lsp-config/
│   │   ├── completion-config/
│   │   └── ...
│   └── rajnvim/
│       └── bootstrap.lua
├── ftplugin/
│   └── java.lua                 # Java-specific config (nvim-jdtls)
├── install-plugins.sh           # Install all plugins
├── install-mason-packages.sh    # Install Mason packages
├── update-plugins.sh            # Update all plugins
└── INSTALL.md                   # This file

~/.local/share/nvim/
├── site/pack/vendor/
│   ├── start/                   # Auto-loaded plugins (147+)
│   └── opt/                     # Optional plugins (loaded on demand)
└── mason/
    ├── packages/                # Mason package installations
    └── share/
        ├── java-debug-adapter/  # Java debug JARs
        └── java-test/           # Java test JARs
```

## Keybindings Reference

### Debug Keybindings
- `Space + d + b` - Toggle breakpoint
- `Space + d + B` - Clear all breakpoints
- `Space + d + C` - Conditional breakpoint
- `Space + d + c` - Continue debugging
- `Space + d + r` - Toggle REPL
- `Space + d + t` - Toggle breakpoint (alternative)
- `Space + d + so` - Step over
- `Space + d + si` - Step into
- `Space + d + l` - Run last

### Diagnostics (Changed)
- `Space + l + d` - Show buffer diagnostics (moved from `Space + d`)

## Additional Resources

- **Neovim docs:** `:help`
- **Mason docs:** `:help mason.nvim`
- **DAP docs:** `:help dap.txt`
- **JDTLS docs:** `:help nvim-jdtls`

## Getting Help

1. Check Neovim messages: `:messages`
2. Check Mason logs: `:MasonLog`
3. Check DAP logs: Set `vim.g.dap_log_level = "TRACE"` and check `:DapShowLog`
4. Check LSP logs: `:LspLog`

## Maintenance

**Weekly:**
- Update plugins: `~/.config/nvim/update-plugins.sh`

**Monthly:**
- Clean unused Mason packages: `:MasonUninstallAll` (then reinstall needed ones)
- Review plugin list for updates

**As Needed:**
- Add new plugins: Edit `install-plugins.sh`, add to `plugins` array, run script
- Add new Mason packages: Edit `install-mason-packages.sh`, add to respective array, run script
