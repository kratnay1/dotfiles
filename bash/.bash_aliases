# enable alias expansion
shopt -s expand_aliases  
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias pgrep='egrep --color=auto'
fi

# general
alias sp='source ~/.profile'
alias xp='source ~/.xprofile'
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias c='cat'
alias m='make'
alias f='fg'
alias fd='fdfind'
alias vi='nvim'

# general directories
alias ..='cd ..'
alias dl='cd ~/Downloads'
alias doc='cd ~/Documents'
alias desk='cd ~/Desktop'
alias dot='cd ~/dotfiles'
alias te='cd ~/test'
alias sc='cd ~/scripts'
alias nv='cd ~/.config/nvim'
alias proj='cd ~/projects'
alias tproj='cd ~/test/projects'
alias o='cd ~/'
alias r='cd /'

# edit files
alias vr='vi ~/.config/nvim/init.vim'
alias br='vi ~/.bashrc'
alias ba='vi ~/.bash_aliases'
alias conf='vi ~/.tmux.conf'
alias xi='vi ~/scripts/xinput_config' 
alias notes='vi ~/test/notes.txt'

# git
alias g='git'
alias gs='git status'
alias gss='git status -s'
alias ga='git add -A'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -am'
alias gd='git diff'
alias gl='git log --graph --oneline --decorate'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcom='git checkout main'
alias gf='git fetch'
alias gp='git pull'
alias gph='git push'
alias gsl='git stash list'
alias gr='cd $(git rev-parse --show-toplevel)' # go to git root dir

# research
alias sgd='cd ~/lab/sgd'
alias sgt='cd ~/lab/sgt-py/'
alias res='cd ~/lab/sgd/decomp/'
alias pyt="ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags . $(python3 -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")"
alias md='make -C /home/kush/lab/sgt-py/docs/ html'
alias jn='jupyter notebook'
alias i='ipython3 --profile=sgd'
alias p='wc -l *' # check progress on num files created

# case-explorer
alias ce='cd ~/ojb/CaseExplorer/'
alias ch='cd ~/ojb/CaseHarvester/'
alias ve='source .venv/bin/activate'

# bluetooth
alias bt='./scripts/connect-bluetooth.sh'
alias bton='rfkill unblock bluetooth'
alias boff='rfkill block bluetooth'
alias bof='rfkill block bluetooth'

# flux
alias fl='/home/kush/scripts/xflux -z 20850 -k 2000'

# tmux
alias ta='tmux attach'
alias tls='tmux ls'
alias tks='tmux kill-server'

# kubernetes
alias k='kubectl'
complete -F __start_kubectl k

# nts : "Note to self"
function nts {
    args=$@
    echo "$args" >> ~/test/notes.txt
}

# # set bluetooth card profile to a2dp_sink
# function ap {
#     index=$(pacmd list-cards | grep -B 1 bluez | head -1 | awk ' { print $2 } ')
#     pacmd set-card-profile $index a2dp_sink
#     pacmd list-cards | grep '<a2dp_sink>'
# }

# function bt {
#     python3 ~/test/bluetooth_connect.py
#     sink=$(pacmd list-cards | grep '<a2dp_sink>')
#     echo $sink
#     if [ -z "$sink" ]; then
#         ap
#     fi
#     pacmd list-cards | grep '<headset>'
# }



