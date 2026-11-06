#!/usr/bin/env bash
# Restore a previous Neovim config from a backup made by install.sh.
set -euo pipefail

DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-config-backups"

[ -d "$BACKUP_DIR" ] || { echo "No backup directory at $BACKUP_DIR" >&2; exit 1; }
mapfile -t backups < <(find "$BACKUP_DIR" -maxdepth 1 -name '*.tar.gz' -type f | sort -r)
[ "${#backups[@]}" -gt 0 ] || { echo "No backups in $BACKUP_DIR" >&2; exit 1; }

echo "Available backups (newest first):"
for i in "${!backups[@]}"; do echo "  $((i+1)). $(basename "${backups[$i]}")"; done
printf 'Select 1-%d [1]: ' "${#backups[@]}"
read -r sel
sel="${sel:-1}"
[[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -ge 1 ] && [ "$sel" -le "${#backups[@]}" ] || { echo "Invalid selection" >&2; exit 1; }
chosen="${backups[$((sel-1))]}"

printf 'This DELETES %s and restores %s. Continue? [y/N] ' "$DEST" "$(basename "$chosen")"
read -r ans
case "$ans" in y|Y|yes|YES) ;; *) echo "Aborted."; exit 1 ;; esac

rm -rf -- "$DEST"
mkdir -p "$(dirname "$DEST")"
tar -xzf "$chosen" -C "$(dirname "$DEST")"
echo "Restored $DEST from $chosen"
