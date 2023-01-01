#!/usr/bin/env bash

set -e
set -o pipefail

if [[ ! -f /.dockerenv ]]; then
  echo "Executing in host";
  if ! git diff --exit-code; then
    echo "Error: Changes detected on repo. Please commit and push changes before running tests."
    exit 1
  fi
  docker run -it -v "$(pwd)/$(basename "$0"):/root/$(basename "$0")" --workdir /root ubuntu "$0"
  exit 0
fi

echo "Executing inside Docker";

uname
apt-get update
apt-get install -y git curl zsh

echo "Fetching neovim 0.8.2"
curl -s -f -L -O https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-linux64.deb
apt install ./nvim-linux64.deb

echo "Installing vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

git clone https://github.com/andsens/homeshick.git "/root/.homesick/repos/homeshick"
# shellcheck disable=all
source "/root/.homesick/repos/homeshick/homeshick.sh"
echo "y" | homeshick clone pose/dotfiles
echo "Install neovim plugins"
nvim -c "PlugInstall"
bash


