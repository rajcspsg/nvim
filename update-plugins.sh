#!/bin/bash

# Update all plugins in vim.pack directory

PACK_DIR="$HOME/.local/share/nvim/site/pack/vendor/start"

echo "================================================"
echo "  Vim.pack Plugin Updater"
echo "================================================"
echo ""

if [ ! -d "$PACK_DIR" ]; then
  echo "Error: Pack directory not found: $PACK_DIR"
  exit 1
fi

cd "$PACK_DIR" || exit 1

total=0
updated=0
failed=0

for dir in */; do
  total=$((total + 1))
  plugin="${dir%/}"

  if [ ! -d "$dir/.git" ]; then
    echo "[$total] ⚠️  $plugin - Not a git repository"
    continue
  fi

  echo -n "[$total] Updating $plugin... "

  output=$(git -C "$dir" pull --quiet 2>&1)
  exit_code=$?

  if echo "$output" | grep -q "Already up to date"; then
    echo "✓ Up to date"
  elif [ $exit_code -eq 0 ]; then
    echo "✅ Updated!"
    updated=$((updated + 1))
  else
    echo "❌ Failed"
    failed=$((failed + 1))
  fi
done

echo ""
echo "================================================"
echo "  Rebuilding plugins with build steps..."
echo "================================================"
echo ""

# telescope-fzf-native
if [ -d "$PACK_DIR/telescope-fzf-native.nvim" ]; then
  echo "Building telescope-fzf-native.nvim..."
  cd "$PACK_DIR/telescope-fzf-native.nvim" && make 2>&1 | grep -v "^make"
  echo "  ✓ Done"
fi

# LuaSnip jsregexp
if [ -d "$PACK_DIR/LuaSnip" ]; then
  echo "Building LuaSnip jsregexp..."
  cd "$PACK_DIR/LuaSnip" && make install_jsregexp 2>&1 | tail -1
  echo "  ✓ Done"
fi

# Uncomment to rebuild blink.cmp (takes ~2-3 minutes)
# if [ -d "$PACK_DIR/blink.cmp" ]; then
#   echo "Building blink.cmp (this may take a few minutes)..."
#   cd "$PACK_DIR/blink.cmp" && cargo build --release --quiet
#   echo "  ✓ Done"
# fi

echo ""
echo "================================================"
echo "  Summary"
echo "================================================"
echo "Total plugins: $total"
echo "Updated: $updated"
echo "Already up to date: $((total - updated - failed))"
echo "Failed: $failed"
echo ""
echo "Done! Restart Neovim to apply updates."
