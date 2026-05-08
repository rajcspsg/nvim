#!/bin/bash

# Check Neovim installation status

echo "================================================"
echo "  Neovim Installation Status Checker"
echo "================================================"
echo ""

# Check Neovim
echo "🔍 Checking Neovim..."
if command -v nvim > /dev/null 2>&1; then
  nvim_version=$(nvim --version | head -n1)
  echo "  ✅ $nvim_version"
else
  echo "  ❌ Neovim not found"
  echo "     Install from: https://neovim.io"
fi

# Check dependencies
echo ""
echo "🔍 Checking dependencies..."

if command -v git > /dev/null 2>&1; then
  echo "  ✅ Git: $(git --version)"
else
  echo "  ❌ Git not found"
fi

if command -v make > /dev/null 2>&1; then
  echo "  ✅ Make: $(make --version | head -n1)"
else
  echo "  ⚠️  Make not found (needed for some plugins)"
fi

if command -v cargo > /dev/null 2>&1; then
  echo "  ✅ Rust/Cargo: $(cargo --version)"
else
  echo "  ⚠️  Rust/Cargo not found (needed for blink.cmp)"
fi

if command -v node > /dev/null 2>&1; then
  echo "  ✅ Node.js: $(node --version)"
else
  echo "  ⚠️  Node.js not found (needed for some LSP servers)"
fi

# Check plugins
echo ""
echo "🔍 Checking plugins..."
PACK_DIR="$HOME/.local/share/nvim/site/pack/vendor/start"
if [ -d "$PACK_DIR" ]; then
  plugin_count=$(find "$PACK_DIR" -maxdepth 1 -type d | wc -l)
  plugin_count=$((plugin_count - 1)) # subtract parent directory
  echo "  ✅ Plugins installed: $plugin_count"

  # Check critical plugins
  critical_plugins=(
    "nvim-lspconfig"
    "nvim-dap"
    "telescope.nvim"
    "nvim-treesitter"
    "blink.cmp"
    "mason.nvim"
  )

  missing_plugins=()
  for plugin in "${critical_plugins[@]}"; do
    if [ -d "$PACK_DIR/$plugin" ]; then
      echo "    ✓ $plugin"
    else
      echo "    ✗ $plugin (missing)"
      missing_plugins+=("$plugin")
    fi
  done

  if [ ${#missing_plugins[@]} -gt 0 ]; then
    echo ""
    echo "  ⚠️  Missing critical plugins!"
    echo "     Run: ~/.config/nvim/install-plugins.sh"
  fi
else
  echo "  ❌ Plugin directory not found: $PACK_DIR"
  echo "     Run: ~/.config/nvim/install-plugins.sh"
fi

# Check Mason
echo ""
echo "🔍 Checking Mason..."
MASON_DIR="$HOME/.local/share/nvim/mason"
if [ -d "$MASON_DIR" ]; then
  echo "  ✅ Mason directory exists"

  # Check for Mason packages
  if [ -d "$MASON_DIR/packages" ]; then
    package_count=$(find "$MASON_DIR/packages" -maxdepth 1 -type d | wc -l)
    package_count=$((package_count - 1))
    echo "  ✅ Mason packages installed: $package_count"

    # Check critical Mason packages
    critical_packages=(
      "java-debug-adapter"
      "java-test"
      "lua-language-server"
      "typescript-language-server"
    )

    missing_packages=()
    for package in "${critical_packages[@]}"; do
      if [ -d "$MASON_DIR/packages/$package" ]; then
        echo "    ✓ $package"
      else
        echo "    ✗ $package (missing)"
        missing_packages+=("$package")
      fi
    done

    if [ ${#missing_packages[@]} -gt 0 ]; then
      echo ""
      echo "  ⚠️  Missing critical Mason packages!"
      echo "     Run: ~/.config/nvim/install-mason-packages.sh"
    fi
  else
    echo "  ⚠️  Mason packages directory not found"
    echo "     Run: ~/.config/nvim/install-mason-packages.sh"
  fi
else
  echo "  ⚠️  Mason not installed"
  echo "     Run: ~/.config/nvim/install-plugins.sh"
fi

# Check Java debug adapters
echo ""
echo "🔍 Checking Java debug adapters..."
if [ -f "$MASON_DIR/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-"*.jar ]; then
  echo "  ✅ java-debug-adapter JAR found"
else
  echo "  ❌ java-debug-adapter JAR not found"
  echo "     Run: :MasonInstall java-debug-adapter"
fi

if [ -d "$MASON_DIR/packages/java-test/extension/server" ] && [ "$(ls -A $MASON_DIR/packages/java-test/extension/server/*.jar 2>/dev/null)" ]; then
  jar_count=$(ls -1 $MASON_DIR/packages/java-test/extension/server/*.jar 2>/dev/null | wc -l)
  echo "  ✅ java-test JARs found: $jar_count"
else
  echo "  ❌ java-test JARs not found"
  echo "     Run: :MasonInstall java-test"
fi

# Check Treesitter parsers
echo ""
echo "🔍 Checking Treesitter parsers..."
PARSER_DIR="$HOME/.local/share/nvim/site/parser"
if [ -d "$PARSER_DIR" ]; then
  parser_count=$(find "$PARSER_DIR" -name "*.so" | wc -l)
  echo "  ✅ Parsers installed: $parser_count"

  critical_parsers=(
    "lua"
    "java"
    "python"
    "javascript"
    "typescript"
    "dap_repl"
  )

  missing_parsers=()
  for parser in "${critical_parsers[@]}"; do
    if [ -f "$PARSER_DIR/$parser.so" ]; then
      echo "    ✓ $parser"
    else
      echo "    ✗ $parser (missing)"
      missing_parsers+=("$parser")
    fi
  done

  if [ ${#missing_parsers[@]} -gt 0 ]; then
    echo ""
    echo "  ⚠️  Missing critical parsers!"
    echo "     Run: nvim -c ':TSInstall ${missing_parsers[*]}' -c ':q'"
  fi
else
  echo "  ❌ Parser directory not found"
  echo "     Run: nvim -c ':TSUpdate' -c ':q'"
fi

# Check config files
echo ""
echo "🔍 Checking configuration files..."
config_files=(
  "init.lua"
  "lua/keybindings/init.lua"
  "lua/plugins/dap-config/init.lua"
  "ftplugin/java.lua"
)

for file in "${config_files[@]}"; do
  if [ -f "$HOME/.config/nvim/$file" ]; then
    echo "  ✅ $file"
  else
    echo "  ❌ $file (missing)"
  fi
done

# Summary
echo ""
echo "================================================"
echo "  Summary"
echo "================================================"

all_good=true

if ! command -v nvim > /dev/null 2>&1; then
  all_good=false
fi

if [ ! -d "$PACK_DIR" ] || [ $plugin_count -lt 100 ]; then
  all_good=false
fi

if [ ! -d "$MASON_DIR/packages" ] || [ $package_count -lt 5 ]; then
  all_good=false
fi

if [ "$all_good" = true ]; then
  echo "✅ Installation looks good!"
  echo ""
  echo "Next steps:"
  echo "  1. Start Neovim: nvim"
  echo "  2. Open a Java file and test: Space + d + b"
  echo "  3. Check for any errors: :messages"
else
  echo "⚠️  Some issues found. See above for details."
  echo ""
  echo "Recommended actions:"
  echo "  1. Install missing dependencies"
  echo "  2. Run: ~/.config/nvim/install-plugins.sh"
  echo "  3. Run: ~/.config/nvim/install-mason-packages.sh"
  echo "  4. Start Neovim and check: :checkhealth"
fi

echo ""
