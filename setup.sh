#!/bin/bash

BAT_DEB="bat_0.15.4_amd64.deb"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.15.4/$BAT_DEB"

YANK_EXE="win32yank.exe"
YANK_ZIP="win32yank-x64.zip"
YANK_URL="https://github.com/equalsraf/win32yank/releases/download/v0.0.4/$YANK_ZIP"

NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh"
POETRY_URL="https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py"

GO_TAR="go1.15.2.linux-amd64.tar.gz"
GO_URL="https://golang.org/dl/$GO_TAR"

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"

# install packages
function install_arch {
  echo "installing in arch linux..."

  sudo pacman -Syu
  sudo pacman -S \
    zsh git gvim tmux base-devel \
    neovim fzf exa ranger ripgrep \
    bat python neofetch

  yay -S lazygit 

  # install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install_deb {
  echo "installing in ubuntu/debian..."

  sudo apt update && sudo apt upgrade
  sudo apt autoremove
  sudo apt install update-manager-core
  sudo do-release-upgrade -d

  sudo apt install software-properties-common
  sudo add-apt-repository ppa:lazygit-team/release

  sudo apt update
  sudo apt install \
    zsh git vim tmux build-essential \
    neovim fzf ranger lazygit ripgrep \
    python-is-python3 neofetch

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  cargo install exa

  if grep -q -i "microsoft" /proc/version; then
    curl -sLo $HOME/$YANK_ZIP $YANK_URL
    unzip -p $HOME/$YANK_ZIP $YANK_EXE > $HOME/$YANK_EXE
    chmod +x $HOME/$YANK_EXE
    mv $HOME/$YANK_EXE $HOME/bin && rm $HOME/$YANK_ZIP
    # maybe need xclip for real deb distro
  fi

  wget $BAT_URL -O $HOME/$BAT_DEB
  sudo dpkg -i $HOME/$BAT_DEB && rm $HOME/$BAT_DEB
}

# create symlinks
function symlink_invade {
  echo "spamming with symlinks..."

  # dotfiles should be in home dir
  ln -sfn $DOTFILES/vim/vimrc $HOME/.vimrc
  ln -sfn $DOTFILES/zsh/zshrc $HOME/.zshrc
  ln -sfn $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf

  mkdir -p $CONFIG/nvim && \
    ln -sfn $DOTFILES/config/nvim/init.vim $CONFIG/nvim/init.vim
  mkdir -p $CONFIG/fzf && \
    ln -sfn $DOTFILES/config/fzf/key-bindings.zsh $CONFIG/fzf/key-bindings.zsh
    ln -sfn $DOTFILES/config/fzf/completion.zsh $CONFIG/fzf/completion.zsh

  cp -vn $DOTFILES/git/gitconfig $HOME/.gitconfig
  cp -vn $DOTFILES/git/gitignore $HOME/.gitignore

  if type code > /dev/null 2>&1; then
    if grep -q -i "microsoft" /proc/version; then
      echo "using wsl with vscode installed"
      CODE_PATH=$(wslpath "$(wslvar APPDATA)"/Code/User/settings.json)
      cp -v $DOTFILES/vscode/settings.json $CODE_PATH
    elif [[ "$OSTYPE" == "linux"* ]]; then
      echo "using linux with vscode installed"
      ln -sfn $DOTFILES/vscode/settings.json $CONFIG/Code\ -\ OSS/User/settings.json
    fi
  fi
}

# run main entry point
function main {
  if command -v pacman > /dev/null; then
    install_arch
  elif command -v apt > /dev/null; then
    install_deb
  fi

  # install node.js
  wget -qO- $NVM_URL | bash
  nvm install node

  # install poetry
  curl -sSL $POETRY_URL | python

  # install go
  wget $GO_URL -O $HOME/$GO_TAR
  sudo tar -C /usr/local -xzf $HOME/$GO_TAR && rm $HOME/$GO_TAR

  symlink_invade
}

main
