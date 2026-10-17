alias reload="source ~/.zshrc"
alias e=$EDITOR
alias g=egrep
if [[ `uname` == Darwin* ]]
then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias lsa='ls -lah'
alias l='ls -la'
# ll: long listing, newest at the bottom. eza when installed, else plain ls.
if (( $+commands[eza] )); then
  alias ll='eza -la --sort=modified --git --time-style=long-iso --color-scale=age'
else
  alias ll='ls -lhrta'
fi
alias sl=ls # often screw this up

# remote editing via Sublime (rmate/rsub)
alias subl='rmate'

# tmux session shortcuts
alias personal='tmux new-session -A -s personal'
alias work='tmux new-session -A -s work'
