#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
KICKSTART_REPO="https://github.com/nvim-lua/kickstart.nvim.git"
KICKSTART_BRANCH="master"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.local/share/nvim-config-backups"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Required tools
required_bins=(nvim cursor-agent yazi)
missing=()
for bin in "${required_bins[@]}"; do
    command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
done
if (( ${#missing[@]} > 0 )); then
    echo -e "${RED}❌ Missing required dependencies:${NC}"
    for m in "${missing[@]}"; do echo "   - $m"; done
    exit 1
fi
echo -e "${GREEN}✅ Required tools found: nvim, cursor-agent, yazi${NC}"

# Check Neovim version >= 0.10.0
required="0.10.0"
current="$(nvim --version | head -n1 | sed -E 's/.*v([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/')"
newest="$(printf '%s\n%s\n' "$required" "$current" | sort -V | tail -n1)"
if [ "$newest" != "$current" ]; then
    echo -e "${RED}❌ Neovim v$current is too old; need ≥ v$required${NC}" >&2
    exit 1
fi
echo -e "${GREEN}✅ Neovim version v$current (OK)${NC}"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup existing config if present
if [ -e "$NVIM_CONFIG_DIR" ]; then
    ts="$(date +%Y%m%d-%H%M%S)"
    default_backup="nvim-$ts.tar.gz"
    
    echo -e "${YELLOW}📦 Found existing Neovim configuration${NC}"
    echo -e "${BLUE}Default backup name: $default_backup${NC}"
    printf "Enter custom backup name (or press Enter for default): "
    read -r custom_name
    
    if [ -n "$custom_name" ]; then
        # Remove .tar.gz extension if user included it
        custom_name="${custom_name%.tar.gz}"
        backup="$BACKUP_DIR/$custom_name.tar.gz"
    else
        backup="$BACKUP_DIR/$default_backup"
    fi
    
    echo -e "${BLUE}📦 Backing up existing config → $backup${NC}"
    (cd "$HOME/.config" && tar -czf "$backup" "nvim")
    echo -e "${GREEN}✅ Backup complete${NC}"
fi

# Create temporary directory for kickstart
temp_dir="$(mktemp -d)"
trap "rm -rf '$temp_dir'" EXIT

echo -e "${BLUE}📥 Downloading kickstart.nvim...${NC}"
git clone --depth 1 --branch "$KICKSTART_BRANCH" "$KICKSTART_REPO" "$temp_dir"

# Inject custom plugin import into init.lua (idempotent)
if ! grep -v '^\s*--' "$temp_dir/init.lua" | grep -q 'custom.plugins'; then
    echo -e "${BLUE}🔧 Injecting custom plugin import...${NC}"
    sed -i 's|-- { import = .custom.plugins. },|  { import = "custom.plugins" },|' "$temp_dir/init.lua"
fi

# Load custom.options (idempotent)
if ! grep -q 'custom.options' "$temp_dir/init.lua"; then
    echo -e "${BLUE}🔧 Adding custom options loader...${NC}"
    printf '\n-- Load user options\npcall(require, "custom.options")\n' >> "$temp_dir/init.lua"
fi

# Copy custom configurations
echo -e "${BLUE}📁 Copying custom configurations...${NC}"

# Copy nvim/ directory if present
if [ -d "$SCRIPT_DIR/nvim" ]; then
    echo "  → Copying nvim directory"
    cp -r "$SCRIPT_DIR/nvim"/* "$temp_dir/"
fi

# Note: Custom keybindings are now included in nvim/lua/custom/keybindings/

# Install the composed config
echo -e "${BLUE}📥 Installing composed config to $NVIM_CONFIG_DIR${NC}"
mkdir -p "$NVIM_CONFIG_DIR"
rsync -a --delete --no-perms --no-owner --no-group "$temp_dir/" "$NVIM_CONFIG_DIR/"
echo -e "${GREEN}✅ Installed to $NVIM_CONFIG_DIR${NC}"

echo
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo
echo "Next steps:"
echo "  • Run Neovim: nvim"
echo "  • First launch: :Lazy sync"
[ -n "${backup:-}" ] && echo "  • Backup saved: $backup"