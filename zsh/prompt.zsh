autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

user_name(){
  echo "%{$fg_bold[green]%}%n%{$reset_color%}"
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%d%{$reset_color%}"
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
  last_command_walltime=$(($precmd_seconds-$preexec_time))
  echo "$last_command completed in $last_command_walltime seconds"
}


function precmd() {
  if [ "x$TTY" != "x" ]; then
    precmd_seconds="$SECONDS"
  fi
}

function preexec() {
  if [ "x$TTY" != "x" ]; then
    preexec_seconds="$SECONDS"
    last_command="$2"
  fi
}








export PROMPT=$'\n$(user_name) in $(directory_name) at $(current_datetime)\n%{$fg_bold[red]%}-->%{$reset_color%} '

function set_right_prompt {
  # use this function add more stuff to the prompt if necessary
  export RPS1="$RPS1"
}
