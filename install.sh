#!/usr/bin/env bash
# Portable Neovim config installer.
#
#   From a clone:   ./install.sh [options]
#   One-liner:      curl -fsSL https://raw.githubusercontent.com/<owner>/kickstart-config/main/install.sh | bash
#   One-liner+args: curl -fsSL .../install.sh | bash -s -- --yes --sync
#
# Options:
#   --dest DIR     install target (default: ${XDG_CONFIG_HOME:-~/.config}/nvim)
#   --prefix DIR   portable install: put the config in DIR/config and a launcher
#                  in DIR/bin/<name>. DIR can be anywhere and can be moved later.
#                  Your normal ~/.config/nvim is left untouched.
#   --name NAME    launcher / NVIM_APPNAME for --prefix (default: nvim-kickstart)
#   --bin-dir DIR  with --prefix: also symlink the launcher into DIR (e.g. ~/.local/bin)
#   --yes          never prompt (implied when stdin is not a terminal)
#   --no-backup    skip backing up an existing config
#   --sync         run a headless `Lazy! restore` after install
#   -h, --help     show this help
#
# Environment overrides (for the download path):
#   KICKSTART_CONFIG_REPO   GitHub "owner/repo"   (default: TrialAndErrror/kickstart-config)
#   KICKSTART_CONFIG_REF    branch, tag or sha     (default: main)
set -euo pipefail

REPO="${KICKSTART_CONFIG_REPO:-TrialAndErrror/kickstart-config}"
REF="${KICKSTART_CONFIG_REF:-main}"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim-config-backups"
ASSUME_YES=false
DO_BACKUP=true
DO_SYNC=false
PREFIX=""
NAME="nvim-kickstart"
BIN_DIR=""
[ -t 0 ] || ASSUME_YES=true

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
    --dest) [ $# -ge 2 ] || die "--dest needs a directory"; DEST="$2"; shift ;;
    --prefix) [ $# -ge 2 ] || die "--prefix needs a directory"; PREFIX="$2"; shift ;;
    --name) [ $# -ge 2 ] || die "--name needs a value"; NAME="$2"; shift ;;
    --bin-dir) [ $# -ge 2 ] || die "--bin-dir needs a directory"; BIN_DIR="$2"; shift ;;
    --yes|-y) ASSUME_YES=true ;;
    --no-backup) DO_BACKUP=false ;;
    --sync) DO_SYNC=true ;;
    -h|--help) sed -n '2,25p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "Unknown option: $1 (try --help)" ;;
  esac
  shift
done

if [ -n "$PREFIX" ]; then
  case "$NAME" in */*|"") die "--name must be a simple name, got '$NAME'" ;; esac
  mkdir -p "$PREFIX"
  PREFIX="$(cd "$PREFIX" && pwd)"
  DEST="$PREFIX/config"
  BACKUP_PREFIX="portable"
else
  [ -z "$BIN_DIR" ] || die "--bin-dir only makes sense with --prefix"
  BACKUP_PREFIX="nvim"
fi

# ── Requirements ────────────────────────────────────────────────────────────
command -v nvim >/dev/null 2>&1 || die "neovim is not installed (need >= 0.10)"
command -v git  >/dev/null 2>&1 || die "git is required (lazy.nvim bootstraps via git)"

current="$(nvim --version | head -n1 | sed -E 's/.*v([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/')"
[ "$(printf '%s\n%s\n' 0.10.0 "$current" | sort -V | head -n1)" = "0.10.0" ] \
  || die "Neovim v$current is too old; need >= 0.10.0"
ok "Neovim v$current"

# Optional tools: the config works without them but some features degrade.
for bin in rg make gcc yazi tree-sitter; do
  command -v "$bin" >/dev/null 2>&1 || warn "optional tool not found: $bin"
done

# ── Locate the source (local clone, else download) ─────────────────────────
SRC=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  [ -f "$here/nvim/init.lua" ] && SRC="$here/nvim"
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
STAGE="$TMP/stage"; mkdir -p "$STAGE"

if [ -z "$SRC" ]; then
  command -v curl >/dev/null 2>&1 || die "curl is required to download the config"
  command -v tar  >/dev/null 2>&1 || die "tar is required to unpack the config"
  url="https://github.com/$REPO/archive/$REF.tar.gz"
  info "Downloading $REPO@$REF ..."
  mkdir -p "$TMP/dl"
  curl -fsSL "$url" | tar -xz -C "$TMP/dl" --strip-components=1 \
    || die "Download failed: $url"
  [ -f "$TMP/dl/nvim/init.lua" ] || die "Downloaded archive has no nvim/init.lua"
  SRC="$TMP/dl/nvim"
fi
cp -a "$SRC/." "$STAGE/"

# ── Back up and replace ────────────────────────────────────────────────────
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  if $DO_BACKUP; then
    mkdir -p "$BACKUP_DIR"
    backup="$BACKUP_DIR/$BACKUP_PREFIX-$(date +%Y%m%d-%H%M%S).tar.gz"
    if ! $ASSUME_YES; then
      printf 'Existing config at %s will be backed up to %s and replaced. Continue? [Y/n] ' "$DEST" "$backup"
      read -r ans
      case "$ans" in n|N|no|NO) die "Aborted." ;; esac
    fi
    info "Backing up $DEST -> $backup"
    tar -czf "$backup" -C "$(dirname "$DEST")" "$(basename "$DEST")"
    ok "Backup written (restore with ./uninstall.sh)"
  elif ! $ASSUME_YES; then
    printf 'Existing config at %s will be REPLACED with no backup. Continue? [y/N] ' "$DEST"
    read -r ans
    case "$ans" in y|Y|yes|YES) ;; *) die "Aborted." ;; esac
  fi
  # Machine-local plugins survive reinstalls.
  if [ -d "$DEST/lua/local" ]; then
    mkdir -p "$STAGE/lua"
    rm -rf "$STAGE/lua/local"
    cp -a "$DEST/lua/local" "$STAGE/lua/local"
    ok "Preserved $DEST/lua/local"
  fi
  rm -rf -- "$DEST"
fi

# Ensure the local-plugins stub exists (init.lua imports local.plugins).
if [ ! -f "$STAGE/lua/local/plugins/init.lua" ]; then
  mkdir -p "$STAGE/lua/local/plugins"
  cat > "$STAGE/lua/local/plugins/init.lua" <<'LUA'
-- Machine-local plugin specs go in this folder. It is gitignored upstream and
-- preserved across reinstalls by install.sh.

return {}
LUA
fi

mkdir -p "$(dirname "$DEST")"
cp -a "$STAGE" "$DEST"
ok "Installed to $DEST"

# ── Portable launcher ──────────────────────────────────────────────────────
if [ -n "$PREFIX" ]; then
  mkdir -p "$PREFIX/bin"
  LAUNCHER="$PREFIX/bin/$NAME"
  cat > "$LAUNCHER" <<'LAUNCH'
#!/usr/bin/env bash
# Generated by kickstart-config install.sh. Runs nvim with the config that lives
# next to this script, wherever the install directory has been moved to.
src="${BASH_SOURCE[0]}"
while [ -L "$src" ]; do
  d="$(cd -P "$(dirname "$src")" && pwd)"
  src="$(readlink "$src")"
  case "$src" in /*) ;; *) src="$d/$src" ;; esac
done
ROOT="$(cd -P "$(dirname "$src")/.." && pwd)"
APPNAME="@NAME@"

# nvim only reads config from $XDG_CONFIG_HOME/$NVIM_APPNAME, so point that at
# the install dir (self-heals if the install dir was moved).
link="${XDG_CONFIG_HOME:-$HOME/.config}/$APPNAME"
if [ "$(readlink "$link" 2>/dev/null)" != "$ROOT/config" ]; then
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "$link exists and is not a symlink; remove it or reinstall with --name" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$link")"
  ln -sfn "$ROOT/config" "$link"
fi
export NVIM_APPNAME="$APPNAME"
exec nvim "$@"
LAUNCH
  sed -i "s/@NAME@/$NAME/" "$LAUNCHER"
  chmod +x "$LAUNCHER"
  ok "Launcher: $LAUNCHER"

  if [ -n "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
    ln -sfn "$LAUNCHER" "$BIN_DIR/$NAME"
    ok "Linked $BIN_DIR/$NAME"
    case ":$PATH:" in *":$BIN_DIR:"*) ;; *) warn "$BIN_DIR is not on your PATH" ;; esac
  fi
  # Run via the launcher so the config symlink exists before --sync.
  NVIM_CMD=("$LAUNCHER")
else
  NVIM_CMD=(nvim)
fi

if $DO_SYNC; then
  info "Restoring plugins from lazy-lock.json (headless) ..."
  "${NVIM_CMD[@]}" --headless "+Lazy! restore" +qa || warn "Plugin sync failed; run :Lazy restore inside nvim"
fi

echo
if [ -n "$PREFIX" ]; then
  RUN="${BIN_DIR:+$NAME}"; RUN="${RUN:-$PREFIX/bin/$NAME}"
  if [ -z "$BIN_DIR" ]; then
    echo "Add to PATH (e.g. in ~/.bashrc / ~/.zshrc):  ${BLUE}export PATH=\"$PREFIX/bin:\$PATH\"${NC}"
  fi
else
  RUN=nvim
fi
echo "${GREEN}Done.${NC} Next: run ${BLUE}$RUN${NC}$($DO_SYNC || echo " (first launch installs plugins; or run :Lazy restore)")."
