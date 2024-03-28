#!/usr/bin/env bash

set -e
set -o pipefail

if [[ ! "$IN_GUEST" ]]; then
  if [[ "$OSTYPE" == *darwin* ]]; then
    CONTAINER_CMD="finch"
  else
    CONTAINER_CMD="docker"
  fi
  echo "Executing in host";
  if ! git diff --exit-code; then
    echo "Error: Changes detected on repo. Please commit and push changes before running tests."
    exit 1
  fi
  exec $CONTAINER_CMD run -e IN_GUEST=1 -t --platform amd64 -v "$(pwd)/$(basename "$0"):/root/$(basename "$0")" --workdir /root ubuntu "$0"
fi

echo "Executing inside container";

uname

if [[ -x $(which sudo) ]]; then
  sudo apt-get update
  sudo apt-get install -y git curl zsh unzip
else
  apt-get update
  apt-get install -y git curl zsh unzip
fi

echo "Installing mise"
export SHELL="bash"
curl https://mise.jdx.dev/install.sh | sh
if [[ -x $(which sudo) ]]; then
  # TODO This is a hack and it should not be path dependent
  sudo chmod ugo+x /home/runner/.local/bin/mise
  eval "$($HOME/.local/bin/mise activate bash)"
else
  eval "$($HOME/.local/bin/mise activate bash)"
fi
mise install nodejs 18
mise global nodejs 18

echo "Fetching neovim 0.8.2"
curl -s -f -L -O https://github.com/neovim/neovim/releases/download/v0.8.2/nvim-linux64.deb

if [[ -x $(which sudo) ]]; then
  sudo apt install ./nvim-linux64.deb
else
  apt install ./nvim-linux64.deb
fi

echo "Installing vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

git clone https://github.com/andsens/homeshick.git "$HOME/.homesick/repos/homeshick"
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
echo "y" | homeshick clone pose/dotfiles

echo "Installing neovim plugins"
nvim --headless +PlugInstall +qall
nvim --headless +PlugInstall +"w! plug-install.log" +qall
nvim --headless +Mason +"MasonInstall typescript-language-server" +MasonLog +"w! mason-install.log" +qall

set +x

# Assertions
grep -q "cmp-buffer: Already installed"             < plug-install.log
grep -q "cmp-path: Already installed"               < plug-install.log
grep -q "cmp-cmdline: Already installed"            < plug-install.log
grep -q "vim-jdaddy: Already installed"             < plug-install.log
grep -q "fzf: Already installed"                    < plug-install.log
grep -q "mason-lspconfig.nvim: Already installed"   < plug-install.log
grep -q "fzf.vim: Already installed"                < plug-install.log
grep -q "vim-argumentative: Already installed"      < plug-install.log
grep -q "nvim-cmp: Already installed"               < plug-install.log
grep -q "vim-diminactive: Already installed"        < plug-install.log
grep -q "neodev.nvim: Already installed"            < plug-install.log
grep -q "vim-eunuch: Already installed"             < plug-install.log
grep -q "vim-commentary: Already installed"         < plug-install.log
grep -q "indent-blankline.nvim: Already installed"  < plug-install.log
grep -q "cmp-vsnip: Already installed"              < plug-install.log
grep -q "vim-node: Already installed"               < plug-install.log
grep -q "applescript.vim: Already installed"        < plug-install.log
grep -q "nvim-lspconfig: Already installed"         < plug-install.log
grep -q "vim-surround: Already installed"           < plug-install.log
grep -q "typescript-vim: Already installed"         < plug-install.log
grep -q "vim-code-dark: Already installed"          < plug-install.log
grep -q "vim-jsx-typescript: Already installed"     < plug-install.log
grep -q "vim-javascript: Already installed"         < plug-install.log
grep -q "mason.nvim: Already installed"             < plug-install.log
grep -q "vim-vsnip: Already installed"              < plug-install.log
grep -q "vim-jq: Already installed"                 < plug-install.log
grep -q "cmp-nvim-lsp: Already installed"           < plug-install.log
grep -q "editorconfig-vim: Already installed"       < plug-install.log

grep -q "Installation succeeded for Package(name=bash-language-server)"        < mason-install.log
# grep -q "Installation succeeded for Package(name=lua-language-server)"         < mason-install.log
grep -q "Installation succeeded for Package(name=rust-analyzer)"               < mason-install.log
grep -q "Installation succeeded for Package(name=typescript-language-server)"  < mason-install.log
grep -q "Installation succeeded for Package(name=vim-language-server)"         < mason-install.log

echo "All plugins and LSPs have been configured correctly!"

# Uncomment for interactive debugging
# bash


