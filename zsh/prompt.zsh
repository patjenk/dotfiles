autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

# Some extra fun colors:
PINK=$'\e[35;40m'
GREEN=$'\e[32;40m'
ORANGE=$'\e[33;40m'

user_name(){
  echo "%{$fg_bold[green]%}%n%{$reset_color%}"
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%d%{$reset_color%}"
}

machine_name(){
  echo "$PINK%M%{$reset_color%}"
}

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    set_right_prompt
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

precmd_seconds=0
preexec_seconds=0
last_command=""

current_datetime() {
  echo "%{$fg_bold[yellow]%}%D{%Y-%m-%d %T}%{$reset_color%}"
}

last_execution_time() {
  echo "" # newline no matter what
  if [ "x$$last_command" != "x" ]; then
    last_command_walltime=$(( $precmd_seconds - $preexec_seconds))
    echo "$last_command_walltime seconds" 
  fi
}

function precmd() {
  if [ "x$TTY" != "x" ]; then
    precmd_seconds=$SECONDS
  fi
  last_execution_time
}

function preexec() {
  if [ "x$TTY" != "x" ]; then
    preexec_seconds=$SECONDS
    last_command="$2"
  fi
}

# What type of repo am I in?
# Stolen from: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
function prompt_char {
  git branch >/dev/null 2>/dev/null && echo "%{$fg_bold[magenta]%}GIT %{$reset_colors%}" && return
  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[magenta]%}HG %{$reset_colors%}" && return
  echo "%{$fg_bold[magenta]%}. %{$reset_colors%}"
}

export PROMPT=$'$(user_name)@$(machine_name) in $(directory_name) at $(current_datetime)\n$(prompt_char)%{$fg_bold[red]%}-->%{$reset_color%} '

function set_right_prompt {
  # use this function add more stuff to the prompt if necessary
  export RPS1="$RPS1"
}
