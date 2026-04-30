/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew install zsh bat procs dive ripgrep exa zplug git starship
sudo echo /usr/local/bin/zsh >> /etc/shells
chsh -s /usr/local/bin/zsh

git clone https://github.com/riywo/anyenv ~/.anyenv
anyenv install --init
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

cp .zshrc ~/.zshrc
cp -r .config/ ~/.config

compaudit | xargs sudo chmod g-w

anyenv install nodenv
anyenv install rbenv
