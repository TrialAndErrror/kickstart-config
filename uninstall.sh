#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.local/share/nvim-config-backups"

# Check for backup directory and list available backups
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}❌ No backup directory found at $BACKUP_DIR${NC}" >&2
    exit 1
fi

# List available backups
backups=($(find "$BACKUP_DIR" -maxdepth 1 -name "*.tar.gz" -type f 2>/dev/null | sort -r))
if [ ${#backups[@]} -eq 0 ]; then
    echo -e "${RED}❌ No backups found in $BACKUP_DIR${NC}" >&2
    exit 1
fi

echo -e "${YELLOW}📋 Available backups:${NC}"
for i in "${!backups[@]}"; do
    backup_file="${backups[$i]}"
    backup_name="$(basename "$backup_file")"
    backup_date="$(stat -c %y "$backup_file" 2>/dev/null || stat -f %Sm "$backup_file" 2>/dev/null || echo "unknown date")"
    echo "  $((i+1)). $backup_name ($backup_date)"
done

# Get user selection
echo
printf "Select backup to restore (1-${#backups[@]}) or press Enter for latest: "
read -r selection

if [ -z "$selection" ]; then
    # Use the first (newest) backup
    latest="${backups[0]}"
else
    # Validate selection
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#backups[@]} ]; then
        echo -e "${RED}❌ Invalid selection${NC}" >&2
        exit 1
    fi
    latest="${backups[$((selection-1))]}"
fi

echo -e "${YELLOW}⚠️  This will DELETE your current ~/.config/nvim and restore from:${NC}"
echo "  $latest"
printf "Continue? [y/N]: "
read -r ans
case "$ans" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 1 ;;
esac

# Remove current config
if [ -e "$NVIM_CONFIG_DIR" ]; then
    echo -e "${BLUE}🗑  Removing $NVIM_CONFIG_DIR${NC}"
    # First try normal removal
    if ! rm -rf -- "$NVIM_CONFIG_DIR" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Some files have restricted permissions, trying with sudo...${NC}"
        if command -v sudo >/dev/null 2>&1; then
            sudo rm -rf -- "$NVIM_CONFIG_DIR"
        else
            echo -e "${RED}❌ Cannot remove $NVIM_CONFIG_DIR due to permission issues and sudo not available${NC}" >&2
            echo "Please manually remove $NVIM_CONFIG_DIR and try again" >&2
            exit 1
        fi
    fi
fi
mkdir -p "$HOME/.config"

echo -e "${BLUE}♻️  Restoring backup...${NC}"
(cd "$HOME/.config" && tar -xzf "$latest")
echo -e "${GREEN}✅ Restored ~/.config/nvim from: $latest${NC}"