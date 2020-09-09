#!/bin/bash

BAT_DEB="bat_0.15.4_amd64.deb"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.15.4/$BAT_DEB"

YANK_EXE="win32yank.exe"
YANK_ZIP="win32yank-x64.zip"
YANK_URL="https://github.com/equalsraf/win32yank/releases/download/v0.0.4/$YANK_ZIP"

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"

# install packages
function install_arch {
  echo "installing in arch linux..."

  sudo pacman -Syu
  sudo pacman -S \
    zsh git gvim tmux base-devel \
    neovim fzf exa ranger ripgrep \
    bat neofetch

  yay -S lazygit 
}

function install_deb {
  echo "installing in ubuntu/debian..."

  sudo apt update
  sudo apt install update-manager-core
  sudo do-release-upgrade -d

  sudo apt install software-properties-common
  sudo add-apt-repository ppa:lazygit-team/release

  sudo apt update
  sudo apt install \
    zsh git vim tmux build-essential \
    neovim fzf ranger lazygit ripgrep \
    neofetch

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
  ln -s -f $DOTFILES/vim/vimrc $HOME/.vimrc
  ln -s -f $DOTFILES/zsh/zshrc $HOME/.zshrc
  ln -s -f $DOTFILES/tmux/tmux.conf $HOME/.tmux.conf

  mkdir -p $CONFIG/nvim && \
    ln -sfn $DOTFILES/config/nvim/init.vim $CONFIG/nvim/init.vim
  mkdir -p $CONFIG/fzf && \
    ln -sfn $DOTFILES/config/fzf/key-bindings.zsh $CONFIG/fzf/key-bindings.zsh
    ln -sfn $DOTFILES/config/fzf/completion.zsh $CONFIG/fzf/completion.zsh

  cp -vn $DOTFILES/git/gitconfig $HOME/.gitconfig
  cp -vn $DOTFILES/git/gitignore $HOME/.gitignore
}

# run main entry point
function main {
  if command -v pacman > /dev/null; then
    install_arch
  elif command -v apt > /dev/null; then
    install_deb
  fi

  symlink_invade
}

main
