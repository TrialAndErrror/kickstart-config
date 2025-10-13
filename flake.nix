{
  description = "Portable Neovim (Kickstart + my plugins) runnable via `nix run`, with devShell and dependency checks";

  # Usage:
  # launch portable Neovim (uses Kickstart + your overlays)
  # nix run .#run-kickstart

  # optional: drop into a shell with nvim + yazi on PATH
  # nix develop

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    kickstart = {
      url = "github:nvim-lua/kickstart.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, kickstart, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    # 1) Patch Kickstart to import your custom plugins directory.
    kickstartPatched = pkgs.stdenv.mkDerivation {
      name = "kickstart-patched";
      src = kickstart;
      dontBuild = true;
      nativeBuildInputs = [ pkgs.gnused ];
      installPhase = ''
        mkdir -p $out
        cp -r $src/* $out/
        if ! grep -q 'custom.plugins' "$out/init.lua"; then
          sed -i '/require.*lazy.*setup/s|setup({|setup({\n  { import = "custom.plugins" },|' "$out/init.lua"
        fi
      '';
    };

    # 2) Compose Kickstart + your local overlay (your repo has ./nvim).
    nvimConfig = pkgs.symlinkJoin {
      name = "nvim-config";
      paths = [ kickstartPatched ./nvim ];
    };

    # 3) The runnable wrapper (self-checks and launches an isolated Neovim).
    runScript = pkgs.writeShellApplication {
      name = "run-kickstart";
      runtimeInputs = [
        pkgs.coreutils
        pkgs.which
        pkgs.neovim   # provides `nvim` in the app env
      ];
      text = ''
        set -euo pipefail

        # --- Dependency checks (nvim is provided by runtimeInputs anyway) ---
        required_bins=(nvim cursor-agent yazi)
        missing=()
        for bin in "''${required_bins[@]}"; do
          if ! command -v "$bin" >/dev/null 2>&1; then
            missing+=("$bin")
          fi
        done

        if (( ''${#missing[@]} > 0 )); then
          echo "❌ Missing required dependencies:"
          for m in "''${missing[@]}"; do
            echo "   - $m"
          done
          echo ""
          echo "Notes:"
          echo "  • 'cursor-agent' is required by the plugin and must be installed separately (see Cursor's CLI docs)."
          echo "  • 'yazi' is optional unless you use it inside your config."
          echo ""
          echo "Press Enter to continue anyway, or Ctrl+C to abort and install them."
          read -r _
        fi
        # --- End checks ---

        # Isolated config: point XDG_CONFIG_HOME to a temp area and symlink our store config.
        tmp_base="''${XDG_RUNTIME_DIR:-/tmp}/kickstart-nvim-''${USER:-user}"
        mkdir -p "$tmp_base"
        ln -sfn ${nvimConfig} "$tmp_base/nvim"
        export XDG_CONFIG_HOME="$tmp_base"

        # Give this instance separate data/cache dirs so it doesn't touch your main setup.
        export NVIM_APPNAME=kickstart-portable

        exec ${pkgs.neovim}/bin/nvim "$@"
      '';
    };
  in {
    # Build the composed config if you want to inspect it.
    packages.${system}.nvim-config = nvimConfig;

    # `nix run .#run-kickstart` launches the isolated Neovim.
    apps.${system}.run-kickstart = {
      type = "app";
      program = "${runScript}/bin/run-kickstart";
    };

    # Dev shell with common tools; you bring your own cursor-agent (see note below).
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        neovim
        yazi
        ripgrep
        fd
        git
        which
      ];
      shellHook = ''
        echo "DevShell ready. If you need the Cursor Agent CLI, install it and ensure 'cursor-agent' is on PATH."
        echo "Run:  nix run .#run-kickstart"
      '';
    };
  };
}
