# Kickstart Neovim Configuration

A modern, well-structured Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with additional plugins and customizations for enhanced productivity. This configuration uses a simple bash script approach for easy installation with automatic backup functionality.

## 🚀 Quick Start

### Prerequisites

- **Neovim 0.10+**
- **Required tools**: `cursor-agent`, `yazi`, `git`, `rsync`

### Install the Configuration

```bash
# Clone the repository
git clone https://github.com/your-username/kickstart-config.git
cd kickstart-config

# Install the configuration (automatically backs up existing config)
./install.sh

# Start Neovim
nvim
```

### Uninstall/Restore

```bash
# Restore your previous configuration from backup
./uninstall.sh
```

## 📋 Prerequisites

### Required Tools

- **Neovim 0.10+** - [Install Neovim](https://neovim.io/doc/user/install.html)
- **cursor-agent** - AI coding assistant
- **yazi** - Terminal file manager
- **git** - Version control (for downloading kickstart.nvim)
- **rsync** - Efficient file copying

### Installing Dependencies

```bash
# Install Neovim (using your system package manager)
# Ubuntu/Debian: sudo apt install neovim
# Arch/Manjaro: sudo pacman -S neovim
# macOS: brew install neovim

# Install yazi
# Ubuntu/Debian: sudo apt install yazi
# Arch/Manjaro: sudo pacman -S yazi
# macOS: brew install yazi

# Install cursor-agent (depends on your setup)
# Check: https://github.com/xTacobaco/cursor-agent.nvim
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
- `<leader>gc` - Neogit commit
- `<leader>gp` - Neogit pull
- `<leader>gP` - Neogit push
- `<leader>gb` - Neogit checkout branch
- `<leader>gd` - Open diff view
- `<leader>gh` - File history
- `<leader>gt` - Git branches (Telescope)
- `<leader>gT` - Git commits (Telescope)
- `<leader>gS` - Git status (Telescope)
- `]h`/`[h` - Next/previous Git hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk

### AI Assistant
- `<leader>cc` - Toggle Cursor Agent terminal
- `<leader>cC` - Send entire buffer to AI
- `<leader>cc` (visual mode) - Send selection to AI

### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>ww` - Switch to next window/panel
- `<leader>wW` - Switch to previous window/panel
- `<leader>wh/j/k/l` - Go to specific window (left/bottom/top/right)
- `<leader>ws` - Split horizontal
- `<leader>wv` - Split vertical
- `<leader>wd` - Close window
- `<leader>wo` - Only window (close others)
- `<leader>w=` - Equalize window sizes
- `<leader>w+/-` - Increase/decrease window height
- `<leader>w>/<` - Increase/decrease window width
- `<leader>wr` - Rotate windows
- `<leader>wx` - Exchange windows
- `<leader>q` - Open diagnostic quickfix list

### Code Actions
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `grn` - Rename symbol
- `gra` - Code actions
- `grd` - Go to definition
- `grr` - Find references

## 🛠️ Installation Method

**Scripts:**
- `install.sh` - Main installation script with backup functionality
- `uninstall.sh` - Uninstall/restore script with backup selection

## 🗂️ Configuration Structure

### Repository Structure
```
kickstart-config/
├── install.sh                 # Bash installation script
├── uninstall.sh               # Bash uninstall/restore script
├── my-config.lua              # Main configuration file
└── nvim/
    └── lua/
        └── custom/
            ├── options.lua    # Global options
            ├── keybindings/   # Custom keybinding modules
            │   ├── init.lua
            │   ├── buffer.lua
            │   ├── code.lua
            │   ├── file.lua
            │   ├── git.lua
            │   ├── lsp.lua
            │   ├── project.lua
            │   ├── quit.lua
            │   ├── search.lua
            │   ├── toggle.lua
            │   └── window.lua
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
3. Reinstall: `./install.sh`
4. Restart Neovim or run `:Lazy reload`

### Modifying Key Bindings
1. Edit files in `nvim/lua/custom/keybindings/`
2. Reinstall: `./install.sh`
3. Restart Neovim

### Changing Theme
1. Edit the colorscheme in `my-config.lua` (line ~884)
2. Available themes: `tokyonight-night`, `tokyonight-storm`, `tokyonight-moon`, `tokyonight-day`
3. Reinstall: `./install.sh`

## 🐛 Troubleshooting

### Common Issues

**Installation fails:**
```bash
# Check if required tools are installed
command -v nvim cursor-agent yazi git rsync

# Install missing tools using your system package manager
# Ubuntu/Debian: sudo apt install neovim yazi git rsync
# Arch/Manjaro: sudo pacman -S neovim yazi git rsync
# macOS: brew install neovim yazi git rsync
```

**Missing dependencies:**
```bash
# Install missing tools:
# Ubuntu/Debian: sudo apt install yazi
# Arch/Manjaro: sudo pacman -S yazi
# macOS: brew install yazi

# Install cursor-agent according to your setup
# Check: https://github.com/xTacobaco/cursor-agent.nvim
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
./uninstall.sh

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

**Script permission issues:**
```bash
# Make scripts executable
chmod +x install.sh uninstall.sh
```

### Getting Help
- Run `:help` in Neovim for built-in help
- Use `<leader>sh` to search help topics
- Check `:Lazy` for plugin status and documentation
- Check the [Bash script documentation](README-bash.md) for detailed script information

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
