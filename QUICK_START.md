# Quick Start Guide

## Installation (First Time)

```bash
# 1. Install plugins (5-10 minutes)
~/.config/nvim/install-plugins.sh

# 2. Install Mason packages (3-5 minutes)
~/.config/nvim/install-mason-packages.sh

# 3. Start Neovim
nvim
```

## Update Everything

```bash
~/.config/nvim/update-plugins.sh
```

## Essential Keybindings

### Debug (Space + d)
| Key         | Action                  |
|-------------|-------------------------|
| `Space d b` | Toggle breakpoint       |
| `Space d B` | Clear all breakpoints   |
| `Space d C` | Conditional breakpoint  |
| `Space d c` | Continue debugging      |
| `Space d r` | Toggle REPL            |
| `Space d so`| Step over              |
| `Space d si`| Step into              |
| `Space d l` | Run last               |

### LSP
| Key         | Action              |
|-------------|---------------------|
| `gD`        | Go to definition    |
| `K`         | Hover docs          |
| `gi`        | Go to implementation|
| `gr`        | Go to references    |
| `Space rn`  | Rename              |
| `Space ca`  | Code action         |

### File Navigation
| Key         | Action              |
|-------------|---------------------|
| `Ctrl e`    | Toggle NeoTree      |
| `Ctrl h/l/j/k` | Window navigation |

### Diagnostics
| Key         | Action                    |
|-------------|---------------------------|
| `Space ld`  | Buffer diagnostics        |
| `Space aa`  | All workspace diagnostics |
| `[c` / `]c` | Previous/Next diagnostic  |

## Verify Installation

### Check Plugins
```bash
ls ~/.local/share/nvim/site/pack/vendor/start/ | wc -l
# Should show 147+
```

### Check Mason (in Neovim)
```vim
:Mason
```

### Check Java Debug Adapter
```bash
ls ~/.local/share/nvim/mason/share/java-debug-adapter/
```

## Troubleshooting

### Java debugging not working?
```vim
:MasonInstall java-debug-adapter java-test
```

### Space + d + b not working?
Already fixed! Restart Neovim.

### Plugin errors?
```vim
:messages
```

## Full Documentation
See: `~/.config/nvim/INSTALL.md`
