#!/usr/bin/env bash
# Update Neovim installs that were created by this repo's install.sh.
#
#   ./update.sh                 list installs, then update all (asks first)
#   ./update.sh --list          just list them
#   ./update.sh DIR [DIR...]    only update the listed install dirs
#
# Options:
#   --list         list registered installs and exit
#   --pull         `git pull --ff-only` this clone first (when it is a git clone)
#   --adopt DIR    register an existing config dir (e.g. one installed before
#                  update.sh existed) as a plain install, then continue
#   --sync         run a headless `Lazy! restore` after each update
#   --no-backup    skip backups
#   --yes          don't prompt
#   -h, --help     show this help
#
# Each update re-runs install.sh with the options the install was created with
# (a backup is taken and lua/local/ is preserved, same as a normal reinstall).
# Installs are recorded in ${XDG_DATA_HOME:-~/.local/share}/kickstart-config/installs.tsv
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="${XDG_DATA_HOME:-$HOME/.local/share}/kickstart-config/installs.tsv"
LIST_ONLY=false; PULL=false; ASSUME_YES=false; SYNC=false; NO_BACKUP=false
ADOPT=(); ONLY=()

if [ -t 1 ]; then
  RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[1;33m'; BLUE=$'\033[0;34m'; NC=$'\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; BLUE=''; NC=''
fi
info() { echo "${BLUE}$*${NC}"; }
ok()   { echo "${GREEN}✓ $*${NC}"; }
warn() { echo "${YELLOW}! $*${NC}" >&2; }
die()  { echo "${RED}✗ $*${NC}" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --list) LIST_ONLY=true ;;
    --pull) PULL=true ;;
    --adopt) [ $# -ge 2 ] || die "--adopt needs a directory"; ADOPT+=("$2"); shift ;;
    --sync) SYNC=true ;;
    --no-backup) NO_BACKUP=true ;;
    --yes|-y) ASSUME_YES=true ;;
    -h|--help) sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "Unknown option: $1 (try --help)" ;;
    *) ONLY+=("$1") ;;
  esac
  shift
done

[ -x "$HERE/install.sh" ] || die "install.sh not found next to update.sh (run this from a clone of the repo)"
[ -f "$HERE/nvim/init.lua" ] || die "$HERE/nvim/init.lua missing; update.sh needs a clone of the repo"

mkdir -p "$(dirname "$REGISTRY")"
touch "$REGISTRY"

for d in ${ADOPT[@]+"${ADOPT[@]}"}; do
  [ -d "$d" ] || die "--adopt: $d is not a directory"
  d="$(cd "$d" && pwd)"
  if ! awk -F'\t' -v d="$d" '$2 == d {f=1} END {exit !f}' "$REGISTRY"; then
    printf 'config\t%s\t\t\t\n' "$d" >> "$REGISTRY"
    ok "Registered $d"
  fi
done

# Load registry, dropping entries whose config dir no longer exists.
kinds=(); dests=(); prefixes=(); names=(); bins=()
while IFS=$'\t' read -r kind dest prefix name bin; do
  [ -n "$dest" ] || continue
  if [ ! -d "$dest" ]; then warn "skipping missing install: $dest"; continue; fi
  if [ "${#ONLY[@]}" -gt 0 ]; then
    match=false
    for o in "${ONLY[@]}"; do
      [ "$(cd "$o" 2>/dev/null && pwd || echo "$o")" = "$dest" ] && match=true
      [ "$prefix" ] && [ "$(cd "$o" 2>/dev/null && pwd || echo "$o")" = "$prefix" ] && match=true
    done
    $match || continue
  fi
  kinds+=("$kind"); dests+=("$dest"); prefixes+=("$prefix"); names+=("$name"); bins+=("$bin")
done < "$REGISTRY"

if [ "${#dests[@]}" -eq 0 ]; then
  echo "No installs found in $REGISTRY."
  echo "Installs made with install.sh are recorded automatically; for an older one run:"
  echo "  ./update.sh --adopt ~/.config/nvim"
  exit 0
fi

echo "Installs from this repo:"
for i in "${!dests[@]}"; do
  if [ "${kinds[$i]}" = portable ]; then
    echo "  $((i+1)). ${dests[$i]}  (portable: ${names[$i]}${bins[$i]:+, linked in ${bins[$i]}})"
  else
    echo "  $((i+1)). ${dests[$i]}"
  fi
done
echo "Source: $HERE"
$LIST_ONLY && exit 0

if $PULL; then
  if [ -d "$HERE/.git" ]; then
    info "git pull --ff-only ..."
    git -C "$HERE" pull --ff-only || die "git pull failed; resolve it and re-run"
  else
    warn "--pull: $HERE is not a git clone, skipping"
  fi
fi

if ! $ASSUME_YES; then
  [ -t 0 ] || die "stdin is not a terminal; pass --yes to update non-interactively"
  printf 'Update %d install(s) from %s? [Y/n] ' "${#dests[@]}" "$HERE"
  read -r ans
  case "$ans" in n|N|no|NO) die "Aborted." ;; esac
fi

failed=0
for i in "${!dests[@]}"; do
  echo
  info "Updating ${dests[$i]} ..."
  args=(--yes)
  $SYNC && args+=(--sync)
  $NO_BACKUP && args+=(--no-backup)
  if [ "${kinds[$i]}" = portable ]; then
    args+=(--prefix "${prefixes[$i]}" --name "${names[$i]}")
    [ -z "${bins[$i]}" ] || args+=(--bin-dir "${bins[$i]}")
  else
    args+=(--dest "${dests[$i]}")
  fi
  if "$HERE/install.sh" "${args[@]}"; then ok "Updated ${dests[$i]}"; else warn "Failed: ${dests[$i]}"; failed=$((failed+1)); fi
done

echo
[ "$failed" -eq 0 ] && ok "All installs updated." || die "$failed install(s) failed."
