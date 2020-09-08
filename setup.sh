#!/bin/bash

BAT_VER="bat_0.15.4_amd64.deb"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v0.15.4/$BAT_VER"

# install packages
function install_arch {
  echo "installing in arch linux..."
}

function install_deb {
  echo "installing in ubuntu/debian..."
  sudo add-apt-repository ppa:lazygit-team/release
  sudo apt update
  sudo apt install \
    zsh git vim tmux build-essential \
    neovim fzf ranger lazygit neofetch

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  cargo install exa

  wget $BAT_URL -O "$HOME/$BAT_VER"
  sudo dpkg -i "$HOME/$BAT_VER"
  rm "$HOME/$BAT_VER"
}

# run main entry point
function main {
  if command -v pacman > /dev/null; then
    install_arch
  elif command -v apt > /dev/null; then
    install_deb
  fi
}

main
