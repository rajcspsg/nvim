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

# Check that mason.nvim itself is installed (the plugin, not just its data dir)
MASON_PLUGIN="$HOME/.local/share/nvim/site/pack/vendor/start/mason.nvim"
if [ ! -d "$MASON_PLUGIN" ]; then
  echo "⚠️  mason.nvim plugin not found at $MASON_PLUGIN"
  echo "   Run: ~/.config/nvim/install-plugins.sh"
  exit 1
fi

# Install a space-separated list of Mason packages ($MASON_PKGS) in one headless nvim.
# ":MasonInstall" is async, so "-c MasonInstall -c qall" would quit before anything
# finishes (and 2>/dev/null used to hide the errors). Here we wait for completion.
mason_install() {
  local lua_file
  lua_file="$(mktemp -t mason-install).lua"
  cat > "$lua_file" <<'EOF'
local names = vim.split(vim.env.MASON_PKGS or "", " ", { trimempty = true })
require("mason").setup()
local reg = require("mason-registry")
local pending = #names
reg.refresh(function()
  for _, n in ipairs(names) do
    local ok, pkg = pcall(reg.get_package, n)
    if not ok then
      print("  x " .. n .. ": not found in registry")
      pending = pending - 1
    elseif pkg:is_installed() then
      print("  = " .. n .. " (already installed)")
      pending = pending - 1
    else
      print("  + installing " .. n)
      pkg:once("closed", function()
        pending = pending - 1
        print((pkg:is_installed() and "  ok " or "  FAILED ") .. n)
      end)
      pkg:install()
    end
  end
end)
vim.wait(900000, function() return pending <= 0 end, 200)
EOF
  nvim --headless "+luafile $lua_file" +qall 2>&1
  rm -f "$lua_file"
  echo ""
}

echo "📦 Installing LSP Servers..."
MASON_PKGS="lua-language-server typescript-language-server vtsls gopls jdtls yaml-language-server clojure-lsp dhall-lsp gradle-language-server zls ruff" mason_install

echo "🐛 Installing Debug Adapters..."
MASON_PKGS="java-debug-adapter java-test debugpy js-debug-adapter codelldb delve" mason_install

echo "✨ Installing Formatters..."
MASON_PKGS="prettier stylua shfmt" mason_install

echo "================================================"
echo "  Installation Complete!"
echo "================================================"
echo ""
echo "Review the ok / FAILED lines above. To retry a failed package:"
echo "  nvim, then :MasonInstall <package-name>   (check status with :Mason)"
echo ""
