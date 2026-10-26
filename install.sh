#!/usr/bin/env bash
# 開発に必要なソフトのインストールと、シェル設定の配置を行う。
# .claude の配置は install_dot_claude.sh を使う。
set -euo pipefail

cd "$(dirname "$0")"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon (/opt/homebrew) / Intel (/usr/local) の両方に対応して PATH を通す
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "$brew_bin" ]]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done

brew update
brew install zsh bat procs dive ripgrep eza zplug git starship

# ログインシェルを brew の zsh にする
ZSH_PATH="$(brew --prefix)/bin/zsh"
if ! grep -qx "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH"
fi

# anyenv（exec $SHELL -l の代わりに、このスクリプト内で PATH と init を反映する）
if [[ ! -d "$HOME/.anyenv" ]]; then
  git clone https://github.com/riywo/anyenv "$HOME/.anyenv"
fi
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

if [[ ! -d "$HOME/.config/anyenv/anyenv-install" ]]; then
  anyenv install --init <<<"y"
fi
mkdir -p "$(anyenv root)/plugins"
if [[ ! -d "$(anyenv root)/plugins/anyenv-update" ]]; then
  git clone https://github.com/znz/anyenv-update.git "$(anyenv root)/plugins/anyenv-update"
fi

# prezto
if [[ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

# dotfiles
cp .zshrc ~/.zshrc
mkdir -p ~/.config
cp -R .config/. ~/.config/

# compinit が警告する group 書き込み権限を外す（compaudit は zsh の関数）
insecure_dirs="$(zsh -c 'autoload -U compaudit && compaudit' 2>/dev/null || true)"
if [[ -n "$insecure_dirs" ]]; then
  echo "$insecure_dirs" | xargs sudo chmod g-w
fi

# anyenv 管理下の env（導入済みならスキップ）
for env_name in nodenv rbenv; do
  if [[ ! -d "$(anyenv root)/envs/$env_name" ]]; then
    anyenv install "$env_name"
  fi
done
