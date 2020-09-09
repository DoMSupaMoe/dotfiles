# Customized Dotfiles

This repo contains most of the tools and dev environment setup that I am currently using.

## Tools Setup

Install essential packages and replace the default shell to zsh with downloaded configs.

```bash
# download repo to the home directory
# start setup by running setup script
./setup.sh
```

## DevEnv Setup

It is a little sad that VS Code extensions cannot be auto installed.

Note: in settings.json, the ligature font "Fira Code" needs to be preinstalled.\
Detailed setup can be found in its own repo: https://github.com/tonsky/FiraCode.

List of essential plugins for development:
* ms-vscode-remote.remote-wsl
* ms-vscode.theme-tomorrowkit
* vscodevim.vim
* vscode-icons-team.vscode-icons
* james-yu.latex-workshop
* ms-vscode.cpptools
* dbaeumer.vscode-eslint
* esbenp.prettier-vscode
* ms-python.python
* octref.vetur
* eamodio.gitlens
