source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/hg-completion

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

# Launch byobu. This is probably wrong. How can we check if byobu-launcher exists or if we should just use screen? 
`echo $- | grep -qs i` && byobu-launcher
