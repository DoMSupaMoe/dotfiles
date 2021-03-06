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
  sudo pacman -S --needed\
    zsh git gvim tmux base-devel \
    neovim fzf exa ranger ripgrep \
    bat python neofetch

  yay -S lazygit 

  # install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install_ubuntu {
  echo "installing in ubuntu..."

  sudo apt -y update && sudo apt -y upgrade
  sudo apt -y autoremove
  sudo apt -y install update-manager-core
  sudo do-release-upgrade -d

  sudo apt -y install apt-transport-https \
    ca-certificates curl gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  sudo add-apt-repository ppa:lazygit-team/release
  sudo add-apt-repository "deb [arch=amd64] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  # remove old docker pkgs
  sudo apt remove docker docker-engine docker.io containerd runc

  sudo apt update
  sudo apt -y install \
    zsh git vim tmux build-essential \
    neovim fzf ranger lazygit ripgrep \
    python-is-python3 neofetch \
    docker-ce docker-ce-cli containerd.io

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

function install_fedora {
  echo "installing in fedora..."

  sudo dnf upgrade
  sudo dnf copr enable atim/lazygit -y
  sudo dnf install \
    zsh git vim neovim tmux fzf exa \
    bat ranger lazygit ripgrep neofetch

  sudo dnf groupinstall \
    "Development Tools" "Development Libraries"

  # install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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
  mkdir -p $CONFIG/ranger && \
    ln -sfn $DOTFILES/config/ranger/commands.py $CONFIG/ranger/commands.py
    ln -sfn $DOTFILES/config/ranger/rc.conf $CONFIG/ranger/rc.conf

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
    install_ubuntu
  elif command -v dnf > /dev/null; then
    install_fedora
  fi

  # install poetry
  curl -sSL $POETRY_URL | python

  # install go
  wget $GO_URL -O $HOME/$GO_TAR
  sudo tar -C /usr/local -xzf $HOME/$GO_TAR && rm $HOME/$GO_TAR

  symlink_invade

  chsh -s $(which zsh) && exec /usr/bin/zsh

  # install node.js
  wget -qO- $NVM_URL | bash
  nvm install node
}

main
