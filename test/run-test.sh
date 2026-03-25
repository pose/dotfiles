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
  sudo apt-get install -y git curl zsh unzip build-essential
else
  apt-get update
  apt-get install -y git curl zsh unzip build-essential
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
curl -s -f -L -O https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz

echo "Installing vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

git clone https://github.com/andsens/homeshick.git "$HOME/.homesick/repos/homeshick"
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
echo "y" | homeshick clone pose/dotfiles

echo "Installing neovim plugins"
./nvim-linux64/bin/nvim --headless +PlugInstall +qall
./nvim-linux64/bin/nvim --headless +PlugInstall +"w! plug-install.log" +qall

echo "Installing Mason LSP servers (CI subset only)"
./nvim-linux64/bin/nvim --headless \
  +"lua require('mason-tool-installer').setup({ ensure_installed = {'bash-language-server', 'rust-analyzer', 'typescript-language-server', 'vim-language-server'} })" \
  -c 'autocmd User MasonToolsUpdateCompleted quitall' \
  -c 'MasonToolsInstallSync'
./nvim-linux64/bin/nvim --headless +MasonLog +"w! mason-install.log" +qall

set +x
# Assertions — automatically derived from .vimrc Plug entries
echo "Checking vim-plug plugins..."
EXPECTED_PLUGINS=$(grep -E "^Plug " ~/.vimrc | sed "s/.*'\([^']*\/\)\([^']*\)'.*/\2/")
for plugin in $EXPECTED_PLUGINS; do
  if ! grep -q "$plugin: Already installed" plug-install.log; then
    echo "FAIL: plugin '$plugin' not found in plug-install.log"
    exit 1
  fi
  echo "  OK: $plugin"
done

echo "Checking Mason LSP servers..."
EXPECTED_LSPS="bash-language-server rust-analyzer typescript-language-server vim-language-server"
for lsp in $EXPECTED_LSPS; do
  if ! grep -q "Installation succeeded for Package(name=$lsp)" mason-install.log; then
    echo "FAIL: LSP '$lsp' not found in mason-install.log"
    exit 1
  fi
  echo "  OK: $lsp"
done

echo "All plugins and LSPs have been configured correctly!"

echo "For reference, these are the Neovim LSP/plugins installed:"
echo "---"
cat plug-install.log mason-install.log
echo "---"

# Uncomment for interactive debugging
# bash


