# ---- dotfiles root ----
export DOTFILES="$HOME/.dotfiles"

# ---- completion (fast & safe) ----
# If you keep custom completion functions, uncomment the next line and remove the stray quote.
# fpath=("$DOTFILES/zsh" $fpath)

autoload -Uz compinit
compinit -C

# ---- PATH (keep ~/.bin first if you use it) ----
export PATH="$HOME/.bin:$PATH"

# ---- Homebrew (macOS only) ----
if [ "$(uname)" = "Darwin" ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ---- pyenv (macOS & Ubuntu) ----
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# ---- Plugins (no OMZ) ----
ZSH_PLUGIN_DIR="$HOME/.zsh-plugins"
if [ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ---- Source your modular files from the repo ----
[ -f "$DOTFILES/zsh/paths.zsh"   ] && source "$DOTFILES/zsh/paths.zsh"
[ -f "$DOTFILES/zsh/aliases.zsh" ] && source "$DOTFILES/zsh/aliases.zsh"
[ -f "$DOTFILES/zsh/config.zsh"  ] && source "$DOTFILES/zsh/config.zsh"
[ -f "$DOTFILES/zsh/prompt.zsh"  ] && source "$DOTFILES/zsh/prompt.zsh"

# ---- Per-machine secrets/overrides ----
[ -f "$HOME/.localrc" ] && source "$HOME/.localrc"

# ---- Syntax highlighting (MUST be last) ----
if [ -f "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# (Optional) consider moving to $DOTFILES/zsh/functions.zsh
cat_with_paths() {
  for file in "$@"; do
    if [[ -f "$file" ]]; then
      fullpath="$(realpath "$file")"
      echo "=== $fullpath ==="
      cat "$file"
      echo; echo
    else
      echo "Skipping: $file (not a file)" >&2
    fi
  done
}
