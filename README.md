# Kickstart Neovim Configuration

A modern, well-structured Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with additional plugins and customizations for enhanced productivity. This configuration uses Nix flakes to provide safe installation with automatic backup functionality.

## 🚀 Quick Start

### Prerequisites

- **Nix** (with flakes enabled)
- **Neovim 0.10+**
- **Required tools**: `cursor-agent`, `yazi`

### Install the Configuration

```bash
# Clone the repository
git clone https://github.com/your-username/kickstart-config.git
cd kickstart-config

# Install the configuration (automatically backs up existing config)
nix run .#install

# Start Neovim
nvim
```

### Uninstall/Restore

```bash
# Restore your previous configuration from backup
nix run .#uninstall
```

## 📋 Prerequisites

### Required Tools

- **Nix** (with flakes enabled) - [Install from Zero to Nix](https://zero-to-nix.com/)
- **Neovim 0.10+** - [Install Neovim](https://neovim.io/doc/user/install.html)
- **cursor-agent** - AI coding assistant
- **yazi** - Terminal file manager

### Installing Dependencies

**Install Nix (if not already installed):**
```bash
# Recommended: Install from Zero to Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://get.zerotonix.com | sh

# Enable flakes (if not already enabled)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**Install Neovim:**
```bash
# Using Nix (recommended)
nix profile install nixpkgs#neovim

# Or using your system package manager
# Ubuntu/Debian: sudo apt install neovim
# Arch/Manjaro: sudo pacman -S neovim
# macOS: brew install neovim
```

**Install cursor-agent and yazi:**
```bash
# Using Nix
nix profile install nixpkgs#yazi
# cursor-agent installation depends on your setup
```

## 🎯 Features

### Core Functionality
- **Lazy loading** - Fast startup with lazy.nvim
- **LSP support** - Language Server Protocol integration
- **Auto-completion** - Smart completion with blink.cmp
- **Fuzzy finding** - File and text search with Telescope
- **Git integration** - Comprehensive Git workflow tools
- **File management** - Modern file manager with Yazi
- **Code formatting** - Automatic code formatting
- **Syntax highlighting** - Enhanced syntax with Treesitter

### Custom Plugins & Tools

#### 🔧 Git Suite
A comprehensive Git workflow with three integrated tools:

- **[Neogit](https://github.com/NeogitOrg/neogit)** - Magit-like Git interface
  - Keymaps: `<leader>gg` (status), `<leader>gc` (commit), `<leader>gp` (pull), `<leader>gP` (push), `<leader>gb` (checkout)

- **[Diffview](https://github.com/sindrets/diffview.nvim)** - Git diff viewer
  - Keymaps: `<leader>gd` (open), `<leader>gD` (close), `<leader>gh` (file history), `<leader>gH` (repo history)

- **[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)** - Git signs and hunks
  - Keymaps: `]h`/`[h` (next/prev hunk), `<leader>hs` (stage hunk), `<leader>hr` (reset hunk), `<leader>hp` (preview hunk)

#### 📁 File Management
- **[Yazi](https://github.com/sxyazi/yazi)** - Terminal file manager
  - Neovim Plugin: https://github.com/mikavilpas/yazi.nvim
  - Keymaps: `<leader>-` (open at current file), `<leader>.` (open in cwd), `<c-up>` (toggle)

#### 🤖 AI Integration
- **[Cursor Agent](https://github.com/xTacobaco/cursor-agent.nvim)** - AI-powered coding assistant
  - Keymaps: `<leader>ca` (toggle terminal), `<leader>cA` (send buffer), `<leader>ca` in visual mode (send selection)

#### 🔍 Search & Navigation
- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
  - Keymaps: `<leader>sf` (find files), `<leader>sg` (live grep), `<leader>sh` (help), `<leader>sk` (keymaps)

#### 🎨 UI & Themes
- **[Tokyo Night](https://github.com/folke/tokyonight.nvim)** - Beautiful color scheme
- **[Which Key](https://github.com/folke/which-key.nvim)** - Key binding helper

#### ⚡ Performance & Utilities
- **[Lazy.nvim](https://github.com/folke/lazy.nvim)** - Plugin manager
- **[Mini.nvim](https://github.com/echasnovski/mini.nvim)** - Collection of utilities
- **[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Syntax highlighting

## ⌨️ Key Bindings

### Leader Key
- **Leader**: `<Space>` (most keymaps start with this)

### File Operations
- `<leader>sf` - Find files
- `<leader>sg` - Live grep
- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps
- `<leader>-` - Open Yazi file manager
- `<leader>.` - Open Yazi in current directory

### Git Operations
- `<leader>gg` - Open Neogit status
- `<leader>gc` - Commit changes
- `<leader>gp` - Pull changes
- `<leader>gP` - Push changes
- `<leader>gb` - Checkout branch
- `<leader>gd` - Open diff view
- `<leader>gh` - File history
- `]h`/`[h` - Next/previous Git hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk

### AI Assistant
- `<leader>ca` - Toggle Cursor Agent terminal
- `<leader>cA` - Send entire buffer to AI
- `<leader>ca` (visual mode) - Send selection to AI

### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>q` - Open diagnostic quickfix list

### Code Actions
- `<leader>f` - Format code
- `grn` - Rename symbol
- `gra` - Code actions
- `grd` - Go to definition
- `grr` - Find references

## 🛠️ Configuration Structure

### Repository Structure
```
kickstart-config/
├── flake.nix                  # Nix flake configuration
├── flake.lock                 # Nix flake lock file
├── my-config.lua              # Main configuration file
├── lua/
│   └── custom/
│       └── keybindings/       # Custom keybinding modules
│           ├── init.lua
│           ├── file.lua
│           ├── git.lua
│           ├── lsp.lua
│           └── ...
└── nvim/
    └── lua/
        └── custom/
            ├── options.lua    # Global options
            └── plugins/       # Custom plugin configurations
                ├── init.lua
                ├── git-suite.lua
                ├── yazi.lua
                └── cursor-agent.lua
```

### Backup Location
```
~/.local/share/nvim-config-backups/
└── nvim-YYYYMMDD-HHMMSS.tar.gz  # Timestamped backups
```

## 🔧 Customization

### Adding New Plugins
1. Create a new file in `nvim/lua/custom/plugins/`
2. Return a plugin configuration table
3. Reinstall: `nix run .#install`
4. Restart Neovim or run `:Lazy reload`

### Modifying Key Bindings
1. Edit files in `lua/custom/keybindings/`
2. Reinstall: `nix run .#install`
3. Restart Neovim

### Changing Theme
1. Edit the colorscheme in `my-config.lua` (line ~884)
2. Available themes: `tokyonight-night`, `tokyonight-storm`, `tokyonight-moon`, `tokyonight-day`
3. Reinstall: `nix run .#install`

### Development Workflow
```bash
# Make changes to your configuration
# Edit files in nvim/ or lua/ directories

# Test the changes
nix run .#install

# If something goes wrong, restore backup
nix run .#uninstall
```

## 🐛 Troubleshooting

### Common Issues

**Installation fails:**
```bash
# Check if Nix flakes are enabled
nix flake --version

# Enable flakes if needed
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

**Missing dependencies:**
```bash
# The install script checks for required tools
# Install missing tools:
nix profile install nixpkgs#yazi
# Install cursor-agent according to your setup
```

**Plugins not loading:**
```bash
# Check plugin status
:Lazy

# Update all plugins
:Lazy update

# Restart Neovim
:qa
nvim
```

**LSP not working:**
```bash
# Check LSP status
:LspInfo

# Install LSP servers
:Mason
```

**Configuration issues:**
```bash
# Restore from backup
nix run .#uninstall

# Or check backup directory
ls ~/.local/share/nvim-config-backups/
```

**Performance issues:**
```bash
# Check startup time
:StartupTime

# Check health
:checkhealth
```

### Getting Help
- Run `:help` in Neovim for built-in help
- Use `<leader>sh` to search help topics
- Check `:Lazy` for plugin status and documentation
- Check the [Nix flakes documentation](https://nixos.wiki/wiki/Flakes)

## 📚 Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide](https://learnxinyminutes.com/docs/lua/)
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Original base configuration
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)

## 📄 License

This configuration is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and follows the same MIT license.

## 🙏 Acknowledgments

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - The excellent base configuration
- All plugin authors and maintainers
- The Neovim community

---

**Happy coding! 🚀**
