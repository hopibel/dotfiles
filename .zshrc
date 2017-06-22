# emacs bindings
bindkey -e

# fix keys broken by zsh not reading /etc/inputrc
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[8~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# environment variables
if which ruby >/dev/null && which gem >/dev/null; then
	PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi
export PATH="$HOME/bin:$PATH"

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
export PS1="[%n@%m %1~]%(#.#.$) "
export EDITOR='nvim'
export GPG_TTY=`tty`

# completion
autoload -Uz compinit && compinit
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# autocorrection (gets annoying)
#setopt correct_all

# history options
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify

# aliases
alias history='fc -l 1'
alias ls='ls --color=auto'
alias hgrep='history | grep'
alias py2env='source $HOME/py2env/bin/activate'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# disable scroll lock
stty -ixon

# color scheme
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# start tmux session or attach to existing one
if [ -z $TMUX ]; then
	id="`tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1`"
	if [ -z "$id" ]; then
		tmux new-session
	else
		tmux attach-session -t "$ID"
	fi
fi
