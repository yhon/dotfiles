## Default shell configuration
#
# set prompt
# colors enables us to idenfity color by $fg[red].
autoload colors
colors
case ${UID} in
0)
    PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
*)
#
# Color
#
DEFAULT=$'%{\e[1;0m%}'
RESET="%{${reset_color}%}"
#GREEN=$'%{\e[1;32m%}'
GREEN="%{${fg[green]}%}"
#BLUE=$'%{\e[1;35m%}'
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
WHITE="%{${fg[white]}%}"
#
# Prompt
#
setopt prompt_subst
#PROMPT='${fg[white]}%(5~,%-2~/.../%2~,%~)% ${RED} $ ${RESET}'
PROMPT='${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}'
RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}'
    ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# beepを鳴らさないようにする
setopt nolistbeep

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0

# 補完キー（Tab,  Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# 登録済コマンド行は古い方を削除
setopt hist_ignore_all_dups

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## Completion configuration
#
autoload -U compinit
compinit

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -alG"
    zle -N expand-to-home-or-insert
    bindkey "@"  expand-to-home-or-insert
    ;;
linux*)
    alias la="ls -al"
    ;;
esac

eval "$(rbenv init -)"
# source /usr/local/Cellar/rbenv/0.3.0/completions/rbenv.zsh

#=============================
# source auto-fu.zsh
#=============================
if [ -f ~/.zsh/auto-fu.zsh ]; then
    source ~/.zsh/auto-fu.zsh
    function zle-line-init () {
        auto-fu-init
    }
    zle -N zle-line-init
    zstyle ':completion:*' completer _oldlist _complete
fi

# rmtrash
alias rm="rmtrash"