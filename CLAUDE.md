# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A [homeshick](https://github.com/andsens/homeshick)-managed dotfiles repo. Homeshick symlinks files from `home/` into `$HOME`.

## Architecture

- `home/` — mirrors the home directory layout 1:1 (e.g., `home/.zshrc` → `~/.zshrc`, `home/.config/nvim/init.vim` → `~/.config/nvim/init.vim`)
- `home/bin/` — user scripts on `$PATH` (bootstrap-macos.sh, setup helpers)
- `home/.config/nvim/` — Neovim config: `init.vim` (vim-plug plugins) + `lua/pose.lua` (LSP/completion setup via Mason)
- `test/` — Docker/Finch-based integration test

## Testing

Run the integration test (requires Docker on Linux, Finch on macOS):

```sh
cd test && ./run-test.sh
```

The test spins up an Ubuntu container, clones the dotfiles via homeshick from GitHub, installs Neovim plugins, and asserts all expected plugins and LSPs are installed. It requires changes to be committed and pushed first.

In CI, the same test runs with `IN_GUEST=1` (already inside the runner):

```sh
cd test && IN_GUEST=1 ./run-test.sh
```

## Key Details

- Plugin management: vim-plug (versions pinned in `home/.vim-plug-lock.vim`)
- LSP management: Mason + mason-lspconfig (configured in `home/.config/nvim/lua/pose.lua`)
- Shell: zsh with oh-my-zsh (custom theme at `home/.oh-my-zsh/themes/pose.zsh-theme`)
- When adding/removing Neovim plugins, update both the Neovim config and the grep assertions in `test/run-test.sh`
