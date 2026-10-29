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

# Claude Code accounts: each alias runs claude with that account's config dir.
alias claude-pj='CLAUDE_CONFIG_DIR=~/.claude-pj command claude'
alias claude-hc-pj='CLAUDE_CONFIG_DIR=~/.claude-hc-pj command claude'
alias claude-hc-tech='CLAUDE_CONFIG_DIR=~/.claude-hc-tech command claude'

# Plain `claude` asks which account to use. It passes straight through when
# CLAUDE_CONFIG_DIR is already set, so sessions started by an alias can still
# run claude themselves.
claude() {
  if [[ -n $CLAUDE_CONFIG_DIR ]]; then
    command claude "$@"
    return
  fi
  if [[ ! -t 0 || ! -t 1 ]]; then
    print -u2 "claude: use claude-pj, claude-hc-pj or claude-hc-tech"
    return 1
  fi
  local account PS3='Account: '
  print -u2 "Which Claude account?"
  select account in pj hc-pj hc-tech; do
    [[ -n $account ]] && break
  done
  [[ -z $account ]] && return 1
  CLAUDE_CONFIG_DIR=~/.claude-$account command claude "$@"
}
