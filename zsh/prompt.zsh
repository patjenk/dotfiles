autoload -Uz colors vcs_info && colors
typeset -g PROMPT_DIRTRIM=2

# vcs_info for git branch on right
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats 'git:%b'
zstyle ':vcs_info:git*' actionformats 'git:%b|%a'

precmd() { vcs_info }

# Build prompt depending on connection type
if [[ -n $SSH_CONNECTION ]]; then
  # Remote session: show user@host
  PROMPT='%F{yellow}[%n@%m]%f %F{cyan}%~%f %# '
else
  # Local session: show only host
  PROMPT='%F{yellow}[%m]%f %F{cyan}%~%f %# '
fi

# Right prompt (git branch and exit status)
RIGHT_STATUS='$(ret=$?; ((ret)) && print -r -- "exit:$ret")'
RPROMPT='%F{8}'"$RIGHT_STATUS"'%f %F{magenta}${vcs_info_msg_0_}%f'

