# Minimal, fast prompt with short path and git branch on the right.
autoload -Uz colors vcs_info && colors

# Shorten %~ by trimming to last 2 path components
typeset -g PROMPT_DIRTRIM=2

# ----- vcs_info (git branch) -----
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats 'git:%b'
zstyle ':vcs_info:git*' actionformats 'git:%b|%a'

precmd() { vcs_info }   # populates ${vcs_info_msg_0_}

# Left: short path + prompt char
PROMPT='%F{cyan}%~%f %# '

# Right: non-zero exit status (if any) + git branch
RIGHT_STATUS='$(ret=$?; ((ret)) && print -r -- "exit:$ret")'
RPROMPT='%F{8}'"$RIGHT_STATUS"'%f %F{magenta}${vcs_info_msg_0_}%f'

# Nerd Font option:
# zstyle ':vcs_info:git*' formats ' %b'
