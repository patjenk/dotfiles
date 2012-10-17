autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
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

function precmd {
}

export PROMPT=$'\n%{$fg_bold[yellow]%}%D %{$fg_bold[green]%}%* $(directory_name)\n%{$fg_bold[red]%}-->%{$reset_color%} '

function set_right_prompt {
  # use this function add more stuff to the prompt if necessary
  export RPS1="$RPS1"
}
