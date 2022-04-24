#!/usr/bin/env bash

point_neovim_config_to_vim() {
  info 'pointing neovim to vim config'
  mkdir -p "$HOME/.config/nvim"
  cat > "$HOME/.config/nvim/init.vim" <<EOF
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
EOF
}


point_neovim_config_to_vim
