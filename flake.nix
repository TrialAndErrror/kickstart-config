{
  description = "Kickstart.nvim + my custom config with install/uninstall and safety checks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    kickstart = { url = "github:nvim-lua/kickstart.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, kickstart, ... }:
  let
    system = builtins.currentSystem or "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; };

    nvimConfig = pkgs.stdenv.mkDerivation {
      name = "nvim-config";
      src = kickstart;
      dontBuild = true;
      nativeBuildInputs = [ pkgs.gnused ];
      installPhase = ''
        set -euo pipefail
        mkdir -p "$out"
        cp -r --no-preserve=mode,ownership "$src"/. "$out"/
        chmod -R u+w "$out"

        # Inject { import = "custom.plugins" } into lazy.setup (idempotent)
        # First check if it's already present (ignoring commented lines)
        if ! grep -v '^\s*--' "$out/init.lua" | grep -q 'custom.plugins'; then
          # Replace the commented import line with the actual import
          ${pkgs.gnused}/bin/sed -i 's|-- { import = .custom.plugins. },|  { import = "custom.plugins" },|' "$out/init.lua"
        fi

        # Load custom.options (idempotent)
        if ! grep -q 'custom.options' "$out/init.lua"; then
          printf '\n-- Load user options\npcall(require, "custom.options")\n' >> "$out/init.lua"
        fi

        # Overlay local nvim/ if present
        if [ -d ${self}/nvim ]; then
          echo "Copying nvim directory from ${self}/nvim to $out/"
          cp -r --no-preserve=mode,ownership ${self}/nvim/. "$out"/
          echo "Nvim directory copied"
        fi
        
        # Overlay local lua/ (for custom keybindings) - merge with existing lua/
        if [ -d ${self}/lua ]; then
          echo "Merging lua directory from ${self}/lua to $out/"
          # Copy keybindings directory specifically
          if [ -d ${self}/lua/custom/keybindings ]; then
            mkdir -p "$out/lua/custom/keybindings"
            cp -r --no-preserve=mode,ownership ${self}/lua/custom/keybindings/. "$out/lua/custom/keybindings/"
            echo "Keybindings directory copied"
          fi
        fi
        
        # Show final structure
        echo "Final lua/custom structure:"
        ls -la "$out/lua/custom/" || echo "No lua/custom directory"
        if [ -d "$out/lua/custom/keybindings" ]; then
          echo "Keybindings directory contents:"
          ls -la "$out/lua/custom/keybindings/"
        fi
      '';
    };

    installScript = pkgs.writeShellApplication {
      name = "install-nvim-config";
      runtimeInputs = [ pkgs.rsync pkgs.gnutar pkgs.gzip pkgs.coreutils ];
      text = ''
        set -euo pipefail

        # Required tools
        required_bins=(nvim cursor-agent yazi)
        missing=()
        for bin in "''${required_bins[@]}"; do
          command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
        done
        if (( ''${#missing[@]} > 0 )); then
          echo "❌ Missing required dependencies:"
          for m in "''${missing[@]}"; do echo "   - $m"; done
          exit 1
        fi
        echo "✅ Required tools found: nvim, cursor-agent, yazi"

        # Neovim version >= 0.10.0
        required="0.10.0"
        current="$(nvim --version | head -n1 | sed -E 's/.*v([0-9]+\.[0-9]+(\.[0-9]+)?).*/\1/')"
        newest="$(printf '%s\n%s\n' "$required" "$current" | sort -V | tail -n1)"
        if [ "$newest" != "$current" ]; then
          echo "❌ Neovim v$current is too old; need ≥ v$required" >&2
          exit 1
        fi
        echo "✅ Neovim version v$current (OK)"

        cfg="$HOME/.config/nvim"
        backup_dir="$HOME/.local/share/nvim-config-backups"
        mkdir -p "$backup_dir"

        # Backup old config if present
        if [ -e "$cfg" ]; then
          ts="$(date +%Y%m%d-%H%M%S)"
          backup="$backup_dir/nvim-$ts.tar.gz"
          echo "📦 Backing up existing config → $backup"
          (cd "$HOME/.config" && tar -czf "$backup" "nvim")
          echo "✅ Backup complete"
        fi

        # Install new config
        echo "📥 Installing composed config to $cfg"
        mkdir -p "$cfg"
        rsync -a --delete --no-perms --no-owner --no-group "${nvimConfig}/" "$cfg/"
        echo "✅ Installed to $cfg"

        echo
        echo "Next:"
        echo "  • Run Neovim: nvim"
        echo "  • First launch: :Lazy sync"
        [ -n "''${backup-}" ] && echo "  • Backup saved: $backup"
      '';
    };

    uninstallScript = pkgs.writeShellApplication {
      name = "uninstall-nvim-config";
      runtimeInputs = [ pkgs.gnutar pkgs.gzip pkgs.coreutils ];
      text = ''
        set -euo pipefail

        cfg="$HOME/.config/nvim"
        backup_dir="$HOME/.local/share/nvim-config-backups"

        # Find the newest backup (YYYYMMDD-HHMMSS sorts lexicographically)
        if [ ! -d "$backup_dir" ]; then
          echo "❌ No backup directory found at $backup_dir" >&2
          exit 1
        fi
        latest="$(find "$backup_dir" -maxdepth 1 -name "nvim-*.tar.gz" -type f 2>/dev/null | sort | tail -n1 || true)"
        if [ -z "$latest" ]; then
          echo "❌ No backups found in $backup_dir" >&2
          exit 1
        fi

        echo "This will DELETE your current ~/.config/nvim and restore from:"
        echo "  $latest"
        printf "Continue? [y/N]: "
        read -r ans
        case "$ans" in
          y|Y|yes|YES) ;;
          *) echo "Aborted."; exit 1 ;;
        esac

        # Remove current config
        if [ -e "$cfg" ]; then
          echo "🗑  Removing $cfg"
          # First try normal removal
          if ! rm -rf -- "$cfg" 2>/dev/null; then
            echo "⚠️  Some files have restricted permissions, trying with sudo..."
            if command -v sudo >/dev/null 2>&1; then
              sudo rm -rf -- "$cfg"
            else
              echo "❌ Cannot remove $cfg due to permission issues and sudo not available" >&2
              echo "Please manually remove $cfg and try again" >&2
              exit 1
            fi
          fi
        fi
        mkdir -p "$HOME/.config"

        echo "♻️  Restoring backup..."
        (cd "$HOME/.config" && tar -xzf "$latest")
        echo "✅ Restored ~/.config/nvim from: $latest"
      '';
    };
  in {
    packages.${system}.nvim-config = nvimConfig;

    # Commands:
    #   nix run .#install
    #   nix run .#uninstall
    apps.${system} = {
      install = { type = "app"; program = "${installScript}/bin/install-nvim-config"; };
      uninstall = { type = "app"; program = "${uninstallScript}/bin/uninstall-nvim-config"; };
    };
  };
}
