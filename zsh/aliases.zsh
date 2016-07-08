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
alias ll='ls -lhrta'
alias sl=ls # often screw this up
