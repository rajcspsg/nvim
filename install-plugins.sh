#!/bin/bash

# Install all plugins for vim.pack from scratch

PACK_DIR="$HOME/.local/share/nvim/site/pack/vendor/start"
OPT_DIR="$HOME/.local/share/nvim/site/pack/vendor/opt"

echo "================================================"
echo "  Vim.pack Plugin Installer"
echo "================================================"
echo ""

# Create directories
echo "Creating pack directory structure..."
mkdir -p "$PACK_DIR"
mkdir -p "$OPT_DIR"
echo "  ✓ Done"
echo ""

declare -a plugins=(
"3rd/image.nvim"
"AstroNvim/astrotheme"
"Bekaboo/dropbar.nvim"
"CRAG666/code_runner.nvim"
"HiPhish/rainbow-delimiters.nvim"
"L3MON4D3/LuaSnip"
"LiadOz/nvim-dap-repl-highlights"
"MagicDuck/grug-far.nvim"
"Marskey/telescope-sg"
"MrcJkb/haskell-tools.nvim"
"MunifTanjim/nui.nvim"
"NeogitOrg/neogit"
"Olical/conjure"
"PaterJason/cmp-conjure"
"RRethy/nvim-treesitter-endwise"
"RRethy/vim-illuminate"
"Vigemus/iron.nvim"
"Wansmer/treesj"
"Weissle/persistent-breakpoints.nvim"
"alexghergh/nvim-tmux-navigation"
"akinsho/bufferline.nvim"
"akinsho/git-conflict.nvim"
"akinsho/toggleterm.nvim"
"anuvyklack/fold-preview.nvim"
"anuvyklack/keymap-amend.nvim"
"antoinemadec/FixCursorHold.nvim"
"aaronik/treewalker.nvim"
"bassamsdata/namu.nvim"
"bbjornstad/pretty-fold.nvim"
"boltlessengineer/bufterm.nvim"
"chrisgrieser/nvim-chainsaw"
"cordx56/rustowl"
"crispgm/nvim-go"
"cuducos/yaml.nvim"
"debugloop/telescope-undo.nvim"
"declancm/windex.nvim"
"dnlhc/glance.nvim"
"echasnovski/mini.bufremove"
"erietz/vim-terminator"
"f-person/git-blame.nvim"
"folke/lsp-colors.nvim"
"folke/snacks.nvim"
"folke/trouble.nvim"
"folke/which-key.nvim"
"gen740/SmoothCursor.nvim"
"giuxtaposition/blink-cmp-copilot"
"gpanders/nvim-parinfer"
"guns/vim-sexp"
"is0n/jaq-nvim"
"jay-babu/mason-nvim-dap.nvim"
"jayp0521/mason-null-ls.nvim"
"jmacadie/telescope-hierarchy.nvim"
"jonboh/nvim-dap-rr"
"julienvincent/clojure-test.nvim"
"kazhala/close-buffers.nvim"
"kevinhwang91/nvim-hlslens"
"kiyoon/magick.nvim"
"kosayoda/nvim-lightbulb"
"lawrence-laz/neotest-zig"
"leoluz/nvim-dap-go"
"lewis6991/gitsigns.nvim"
"luc-tielen/telescope_hoogle"
"luckasRanarison/clear-action.nvim"
"lvimuser/lsp-inlayhints.nvim"
"m00qek/baleia.nvim"
"marilari88/neotest-vitest"
"maxbol/treesorter.nvim"
"mfussenegger/nvim-dap"
"mfussenegger/nvim-dap-python"
"mfussenegger/nvim-jdtls"
"mrcjkb/neotest-haskell"
"mrcjkb/rustaceanvim"
"mrbjarksen/neo-tree-diagnostics.nvim"
"neovim/nvim-lspconfig"
"nvim-lua/lsp-status.nvim"
"nvim-lua/plenary.nvim"
"nvim-lualine/lualine.nvim"
"nvim-neo-tree/neo-tree.nvim"
"nvim-neotest/neotest"
"nvim-neotest/neotest-go"
"nvim-neotest/neotest-jest"
"nvim-neotest/nvim-nio"
"nvim-telescope/telescope-fzf-native.nvim"
"nvim-telescope/telescope-symbols.nvim"
"nvim-telescope/telescope-ui-select.nvim"
"nvim-telescope/telescope.nvim"
"nvim-tree/nvim-web-devicons"
"nvim-treesitter/nvim-treesitter"
"nvim-treesitter/nvim-treesitter-context"
"nvim-treesitter/nvim-treesitter-textobjects"
"nvim-treesitter/playground"
"nvimdev/lspsaga.nvim"
"nvimtools/none-ls-extras.nvim"
"nvimtools/none-ls.nvim"
"onsails/lspkind.nvim"
"oskarrrrrrr/symbols.nvim"
"p00f/cphelper.nvim"
"pmizio/typescript-tools.nvim"
"rachartier/tiny-code-action.nvim"
"rachartier/tiny-glimmer.nvim"
"radenling/vim-dispatch-neovim"
"rafamadriz/friendly-snippets"
"rcarriga/nvim-dap-ui"
"rcasia/neotest-java"
"saecki/crates.nvim"
"saghen/blink.cmp"
"saghen/blink.compat"
"saghen/blink.lib"
"scalameta/nvim-metals"
"sindrets/diffview.nvim"
"sphamba/smear-cursor.nvim"
"stevearc/conform.nvim"
"stevearc/overseer.nvim"
"theHamsta/nvim-dap-virtual-text"
"thenbe/neotest-playwright"
"tpope/vim-dispatch"
"tpope/vim-repeat"
"tpope/vim-sexp-mappings-for-regular-people"
"VidocqH/lsp-lens.nvim"
"voldikss/vim-floaterm"
"williamboman/mason-lspconfig.nvim"
"williamboman/mason.nvim"
"windwp/nvim-autopairs"
"windwp/nvim-ts-autotag"
"yioneko/nvim-vtsls"
"zbirenbaum/neodim"
)

echo "Installing ${#plugins[@]} plugins to $PACK_DIR"
echo ""

cd "$PACK_DIR" || exit 1

count=0
success=0
failed=0

for plugin in "${plugins[@]}"; do
  count=$((count + 1))
  repo_name=$(basename "$plugin")

  if [ -d "$repo_name" ]; then
    echo "[$count/${#plugins[@]}] ✓ $plugin (already exists)"
    success=$((success + 1))
  else
    echo -n "[$count/${#plugins[@]}] Cloning $plugin... "
    if git clone --depth=1 "https://github.com/$plugin.git" "$repo_name" > /dev/null 2>&1; then
      echo "✓"
      success=$((success + 1))
    else
      echo "❌"
      failed=$((failed + 1))
    fi
  fi
done

# Special case: lsp_lines.nvim from sr.ht
echo ""
echo "Installing lsp_lines.nvim from sr.ht..."
cd "$PACK_DIR" || exit 1
if [ -d "lsp_lines.nvim" ]; then
  echo "  ✓ Already exists"
else
  if git clone --depth=1 "https://git.sr.ht/~whynothugo/lsp_lines.nvim" lsp_lines.nvim > /dev/null 2>&1; then
    echo "  ✓ Done"
    success=$((success + 1))
  else
    echo "  ❌ Failed"
    failed=$((failed + 1))
  fi
fi

# Move playground to opt
echo ""
echo "Moving playground to opt directory..."
if [ -d "$PACK_DIR/playground" ]; then
  mv "$PACK_DIR/playground" "$OPT_DIR/" 2>/dev/null && echo "  ✓ Done"
else
  echo "  ⚠️  playground not found"
fi

echo ""
echo "================================================"
echo "  Building plugins with compile steps..."
echo "================================================"
echo ""

# telescope-fzf-native
if [ -d "$PACK_DIR/telescope-fzf-native.nvim" ]; then
  echo "Building telescope-fzf-native.nvim..."
  cd "$PACK_DIR/telescope-fzf-native.nvim" && make > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  ✓ Done"
  else
    echo "  ❌ Failed (may need build tools installed)"
  fi
fi

# LuaSnip jsregexp
if [ -d "$PACK_DIR/LuaSnip" ]; then
  echo "Building LuaSnip jsregexp..."
  cd "$PACK_DIR/LuaSnip" && make install_jsregexp > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  ✓ Done"
  else
    echo "  ❌ Failed"
  fi
fi

# blink.cmp (Rust build - takes time)
if [ -d "$PACK_DIR/blink.cmp" ]; then
  echo "Building blink.cmp (this may take 2-3 minutes)..."
  cd "$PACK_DIR/blink.cmp"
  if command -v cargo > /dev/null 2>&1; then
    if cargo build --release > /dev/null 2>&1; then
      echo "  ✓ Done"
    else
      echo "  ❌ Failed (Rust/Cargo may not be installed)"
    fi
  else
    echo "  ⚠️  Skipped (Rust/Cargo not found)"
    echo "     Install Rust from: https://rustup.rs/"
  fi
fi

echo ""
echo "================================================"
echo "  Installation Summary"
echo "================================================"
echo "Total plugins: $((count + 1))"
echo "Successfully installed: $success"
echo "Failed: $failed"
echo ""
echo "================================================"
echo "  Installing Mason packages..."
echo "================================================"
echo ""

# Check if neovim is available
if command -v nvim > /dev/null 2>&1; then
  echo "Installing Mason LSP servers and tools..."

  # Install Mason packages in headless mode
  nvim --headless -c "MasonInstall lua-language-server typescript-language-server" -c "qall" 2>/dev/null &
  sleep 2

  echo "Installing DAP adapters..."
  nvim --headless -c "MasonInstall java-debug-adapter java-test debugpy js-debug-adapter codelldb" -c "qall" 2>/dev/null &
  sleep 2

  echo "Installing formatters..."
  nvim --headless -c "MasonInstall prettier stylua shfmt" -c "qall" 2>/dev/null &
  sleep 2

  echo "Installing Treesitter parsers..."
  nvim --headless -c "TSInstall lua python javascript typescript java dap_repl" -c "sleep 5" -c "qall" 2>/dev/null &
  sleep 3

  echo ""
  echo "  ⚠️  Note: Mason and Treesitter installations run in background"
  echo "     Check status in Neovim with :Mason and :TSInstallInfo"
else
  echo "  ⚠️  Neovim not found, skipping Mason installations"
  echo "     Install Mason packages manually with :MasonInstall"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Wait for Mason background installs to complete (~2-5 minutes)"
echo "  2. Start Neovim: nvim"
echo "  3. Check Mason status: :Mason"
echo "  4. Update plugins: ~/.config/nvim/update-plugins.sh"
echo ""
