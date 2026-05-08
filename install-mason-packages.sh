#!/bin/bash

# Install Mason packages (LSP servers, DAP adapters, formatters, linters)

echo "================================================"
echo "  Mason Package Installer"
echo "================================================"
echo ""

if ! command -v nvim > /dev/null 2>&1; then
  echo "❌ Error: Neovim not found"
  echo "   Please install Neovim first"
  exit 1
fi

# Check if Mason is installed
if [ ! -d "$HOME/.local/share/nvim/mason" ]; then
  echo "⚠️  Mason not found. Installing plugins first..."
  echo "   Run: ~/.config/nvim/install-plugins.sh"
  exit 1
fi

echo "Installing Mason packages in the background..."
echo "This will take 3-5 minutes depending on your connection."
echo ""

# LSP Servers
echo "📦 Installing LSP Servers..."
declare -a lsp_servers=(
  "lua-language-server"
  "typescript-language-server"
  "vtsls"
  "gopls"
  "jdtls"
  "yaml-language-server"
  "clojure-lsp"
  "dhall-lsp"
  "gradle-language-server"
  "zls"
  "ruff"
)

for server in "${lsp_servers[@]}"; do
  echo "  - $server"
done

nvim --headless -c "MasonInstall ${lsp_servers[*]}" -c "qall" 2>/dev/null &
mason_lsp_pid=$!

# DAP Adapters
echo ""
echo "🐛 Installing Debug Adapters..."
declare -a dap_adapters=(
  "java-debug-adapter"
  "java-test"
  "debugpy"
  "js-debug-adapter"
  "codelldb"
  "delve"
)

for adapter in "${dap_adapters[@]}"; do
  echo "  - $adapter"
done

nvim --headless -c "MasonInstall ${dap_adapters[*]}" -c "qall" 2>/dev/null &
mason_dap_pid=$!

# Formatters
echo ""
echo "✨ Installing Formatters..."
declare -a formatters=(
  "prettier"
  "stylua"
  "shfmt"
)

for formatter in "${formatters[@]}"; do
  echo "  - $formatter"
done

nvim --headless -c "MasonInstall ${formatters[*]}" -c "qall" 2>/dev/null &
mason_fmt_pid=$!

echo ""
echo "⏳ Waiting for installations to complete..."
echo "   (This runs in the background, you can check status with :Mason in Neovim)"
echo ""

# Wait for all background processes
wait $mason_lsp_pid 2>/dev/null
wait $mason_dap_pid 2>/dev/null
wait $mason_fmt_pid 2>/dev/null

echo "================================================"
echo "  Installation Complete!"
echo "================================================"
echo ""
echo "✅ All Mason packages have been queued for installation"
echo ""
echo "Next steps:"
echo "  1. Start Neovim: nvim"
echo "  2. Check installation status: :Mason"
echo "  3. If any packages failed, install manually:"
echo "     :MasonInstall <package-name>"
echo ""
echo "Common packages installed:"
echo "  • LSP Servers: ${#lsp_servers[@]} servers"
echo "  • DAP Adapters: ${#dap_adapters[@]} adapters"
echo "  • Formatters: ${#formatters[@]} formatters"
echo ""
