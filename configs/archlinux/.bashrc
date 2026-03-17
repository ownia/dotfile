#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export LD_LIBRARY_PATH=/usr/local/lib
alias lg='lazygit'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rg='rg --hidden --no-ignore'
alias fd='fd --hidden --no-ignore'
alias tmux='tmux -2'
alias nv='nvim'

PATH=$PATH:/home/ownia/git-tools
