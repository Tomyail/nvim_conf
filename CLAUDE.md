# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on LazyVim, customized with additional plugins and settings for an enhanced coding experience. The configuration uses Lua and follows the modern Neovim plugin management approach with `lazy.nvim`.

## Architecture

### Core Structure
- `init.lua` - Entry point that sets up lazy.nvim and loads plugin specifications
- `lua/config/` - Core configuration files (options, keymaps, autocmds)
- `lua/plugins/` - Plugin specifications organized by category
- `yasi/` - Custom input method plugin for CJK language support
- `lua/lsp/` - Language Server Protocol configurations

### Plugin Organization
The plugins are organized into logical modules:
- `plugins/core.lua` - Base configuration (colorscheme)
- `plugins/lsp.lua` - LSP configuration with auto-discovery
- `plugins/ui.lua` - User interface enhancements (dashboard, terminal, file explorer)
- `plugins/editor.lua` - Editor functionality (Neo-tree, Git, Obsidian, custom plugins)
- `plugins/coding.lua` - Development tools
- `plugins/formatting.lua` - Code formatting setup
- `plugins/colorscheme.lua` - Theme configuration

### Key Features
- **Smart Input Method Switching**: Custom `yasi.nvim` plugin for automatic Chinese/English input switching
- **Terminal-Adaptive Navigation**: Automatically chooses between tmux and WezTerm navigation based on environment
- **Obsidian Integration**: Full note-taking workspace with custom templates and daily notes
- **Enhanced File Management**: Neo-tree with custom keybindings and search capabilities
- **Multi-Cursor Editing**: Support for multiple cursor operations

## Development Workflow

### Configuration Management
- Copy `lua/config/options-local.sample.lua` to `lua/config/options-local.lua` for machine-specific settings
- The local options file is loaded automatically if it exists
- Use the local file for paths like Obsidian vault locations

### Key Commands
- `<leader>ee` - Toggle Neo-tree file explorer
- `<leader>ef` - Reveal current file in Neo-tree
- `<leader>tt` - Open floating terminal
- `<leader>t1-4` - Open terminal instances 1-4
- `<leader>F` - Live grep with fzf-lua
- `<leader>oo` - Create quick note in configured directory
- `jk` - Exit insert mode (custom mapping)

### Plugin Management
All plugins are managed through lazy.nvim. Common operations:
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Sync all plugins
- `:Lazy install` - Install missing plugins
- `:Lazy clean` - Clean unused plugins

### LSP Configuration
LSP servers are automatically discovered from files in `lua/lsp/`. Each server configuration file should return the server options to be merged with the default configuration.

## Configuration Details

### Input Method (yasi.nvim)
The custom `yasi.nvim` plugin provides automatic input method switching:
- Switches to English when entering command mode
- Detects CJK characters and switches to appropriate input method
- Configured for macOS with im-select and Rime input method

### Window Navigation
The configuration automatically detects the terminal environment:
- In tmux: Uses vim-tmux-navigator with `<c-h/j/k/l>` bindings
- In WezTerm: Uses smart-splits.nvim with the same bindings
- Detection based on `TERM_PROGRAM` environment variable

### Obsidian Integration
- Daily notes with custom templates in `journals/` directory
- Automatic frontmatter generation with timestamps
- Image attachments stored in `assets/imgs/`
- Note IDs use timestamp format for Zettelkasten-style organization

### Custom Keymaps
- Leader key set to `,` (comma)
- `jk` mapped to `<ESC>` for faster exit from insert mode
- Enhanced Neo-tree mappings for file operations and search

## File Patterns
- Plugin configurations: `lua/plugins/*.lua`
- LSP server configs: `lua/lsp/*.lua`
- Core settings: `lua/config/*.lua`
- Local overrides: `lua/config/options-local.lua` (create from sample)
- Custom plugin: `yasi/` directory