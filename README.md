# Customized Dotfiles

This repo contains most of the tools and dev environment setup that I am currently using.

## Tools Setup

```bash
# install essential packages
sudo apt install git zsh vim tmux build-essential

# download zsh shell and oh-my-zsh config
chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# clone the dotfiles repo into home directory
git clone https://github.com/domsupamoe/dotfiles.git ~/dotfiles

# create sym links for the configs
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
ln -s ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/git/gitignore ~/.gitignore
```

## DevEnv Setup

### VS Code Config

The user settings file location for different OS:

* Windows: %APPDATA%\Code\User\settings.json
* Linux: $HOME/.config/Code/User/settings.json

### Node.js Env

```bash
# install nvm and use nvm to install latest node
wget -qO- https://raw.githubusercontent.com/creationix/nvm/$VERSION/install.sh | bash
nvm install node
```

### Python Env

```bash
# install python version manager
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# install poetry for package dependency management
sudo apt install python-is-python3 python3-venv python3-pip
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
```

### Go Env

```bash
# download the archive and extract it into /usr/local 
curl -O https://storage.googleapis.com/golang/go$VERSION.$OS-$ARCH.tar.gz ~/go$VERSION.$OS-$ARCH.tar.gz
tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
```
