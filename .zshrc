# aliases
alias g='git'
alias cl='clear'
alias gs='g status'
# use Rust binaly
alias ls='exa -a'
alias cat='bat'
alias less='bat'
alias find='fd'
alias ps='procs'
alias grep='rg'

PATH=/usr/local/opt/openssl/bin:$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.anyenv/bin:
export PATH

eval "$(anyenv init -)"

# zplug
source /usr/local/opt/zplug/init.zsh

# 色設定
autoload -U colors; colors

# もしかして機能
setopt correct

# PCRE 互換の正規表現を使う
setopt re_match_pcre

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプト指定
# PROMPT="
# [%n] %{${fg[yellow]}%}%~%{${reset_color}%}
# %(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "

# プロンプト指定(コマンドの続き)
# PROMPT2='[%n]> '

# もしかして時のプロンプト指定
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} "


function auto_cdls()
{
    if [ "$OLDPWD" != "$PWD" ]; then
        ls -a
        OLDPWD="$PWD"
    fi
}

precmd() {  auto_cdls; }

#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit; compinit
autoload -U promptinit; promptinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
eval "$(starship init zsh)"
eval "$(dip console)"

