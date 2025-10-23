if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

#fpath=($ZSH/zsh/functions $fpath)

#autoload -U $ZSH/zsh/functions/*(:t)

HISTFILE=~/.zsh_history                   # Store my history here
HISTSIZE=10000                            # Store my last 10,000 commands
SAVEHIST=10000                            # When I logout, continue to store my last 10,000 commands
setopt INC_APPEND_HISTORY SHARE_HISTORY   # adds history incrementally and share it across sessions
setopt SHARE_HISTORY                      # share history between sessions ???
setopt EXTENDED_HISTORY                   # add timestamps to history
setopt APPEND_HISTORY                     # adds history
setopt HIST_FIND_NO_DUPS                  # When I search my command history, don't show me the dupes
setopt HIST_REDUCE_BLANKS                 # When you enter commands into my history, clean them up. I don't want others seeing my dirt
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward # When I hit ctrl-r, search backwards through my history

setopt ZLE # Zsh Line Editor. This is set by default but why not be exact?
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt PROMPT_SUBST                       # This allows us to put functions into our prompt. HOLY MOLY!
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zle -N newtab

bindkey -e

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
bindkey '^R' history-incremental-search-backward

# virtualenvwrapper stuff.
export WORKON_HOME=~/Envs
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi
export EDITOR=vim
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME

export GREP_COLORS='mt=1;32'
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

if [ -d ~/.pyenv ]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)";
fi
if [ -d ~/.pyenv/plugins/pyenv-virtualenv ]; then
  eval "$(pyenv virtualenv-init -)";
fi
