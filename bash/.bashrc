# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# add datetime stamp to history output
HISTTIMEFORMAT="%Y-%m-%d %T "

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# don't save common commands to history
HISTIGNORE='ls:la:l:ll:k:h:..:fzf_vim:cdf'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# set vim as default editor
export VISUAL=vi
export EDITOR=$VISUAL


find_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1/'
}

find_git_dirty_1() {
    local status=$(git status --porcelain 2> /dev/null)
    if [ ! $(git rev-parse --is-inside-work-tree 2> /dev/null) ]; then
        echo ''
    elif [[ "$status" != "" ]]; then
        echo '*'
    else
        echo ''
    fi
}

find_git_dirty_2() {
    if [ ! $(git rev-parse --is-inside-work-tree 2> /dev/null) ]; then
        echo ''
    else
        echo ') '
    fi
}

if [ "$color_prompt" = yes ]; then
    export PS1="${debian_chroot:+($debian_chroot)}\[\033[00;30m\]\$(find_git_branch)\[\033[00;31m\]\$(find_git_dirty_1)\[\033[00;30m\]\$(find_git_dirty_2)\[\033[00m\]\u:\[\033[00;35m\]\w\[\033[00m\]$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac


# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# vi mode in command line
set -o vi
set keymap vi-insert

stty start undef

# readline macros
bind 'set completion-ignore-case on'
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-d": kill-whole-line'
bind '"\C-o": "> output"'
bind -m vi-insert "\C-l":clear-screen

# make touch pad tolerable
source /home/kush/scripts/xinput_config
source /usr/share/autojump/autojump.sh

# Functions
mcd() { mkdir $1; cd $1; }

# Find a file with a pattern in name:
ff() { find . -type f -iname '*'$*'*' -ls ; }

# prints all ip addresses
# ip() {
#     ifconfig | perl -nle '/dr:(\S+)/ && print $1'
# }

# git log find by commit message
glf() { git log --all --grep="$1"; }

# tmux send command to right pane
ts() {
    args=$@
    tmux send-keys -t right "$args" C-m 
}

# search history (exclude the last entry)
hs() {
    args=$@
    history | head -n-1 | grep "$args"
}

# tmux
if [ -z "$TMUX" ]; then
    tmux attach -t kush || tmux new -s kush
fi

tns() { tmux new-session -s $1; }

## fzf
# original locations
source /usr/share/doc/fzf/examples/key-bindings.bash 
source /usr/share/doc/fzf/examples/completion.bash
source /home/kush/.fzf/key-bindings.bash 
source /home/kush/.fzf/completion.bash
export FZF_DEFAULT_COMMAND='fdfind -H'

open_with_fzf() {
    fd -t f -H -I | fzf -m --reverse --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-
}
bind '"\C-o": "open_with_fzf\n"'

# edit file 
fzf_vim() {
  IFS=$'\n' files=($(fzf --height 40% --reverse --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && "nvim" "${files[@]}"
}
bind '"\C-g": "fzf_vim\n"'

# cd into selected directory or directory of selected file
cdf() {
   local file
   local dir
   file=$(fzf --height 40% --reverse +m)
   if [[ -d $file ]]; then
       cd "$file"
   else
       dir=$(dirname "$file") && cd "$dir"
   fi
}
bind '"\C-q": "cdf\n"'




[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias luamake=/home/kush/.cache/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake
