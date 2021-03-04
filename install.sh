/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap bibendi/dip
brew update
brew install zsh bat procs dip dive ripgrep exa zplug git starship

git clone https://github.com/riywo/anyenv ~/.anyenv
exec $SHELL -l
anyenv install --init
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

cp .zshrc ~/.zshrc
cp -r .config/ ~/.config

anyenv install nodenv
anyenv install rbenv
