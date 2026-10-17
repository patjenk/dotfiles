# patjenk's dotfiles

Shell, tmux, git, and editor configuration for zsh on macOS and Linux. Inspired by ryanb's dotfiles (https://github.com/ryanb/dotfiles).

## Install

```
git clone https://github.com/patjenk/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
python3 install.py install --pretend
python3 install.py install
```

- **What it does:** Symlinks each top-level file and directory in the repo to `~/.<name>` (for example, `zshrc` to `~/.zshrc`, `zsh/` to `~/.zsh`). Skips `README.markdown`, `install.py`, and dot-prefixed entries. Then clones the zsh plugins into `~/.zsh-plugins`.
- **Conflicts:** When a target already exists and differs, the installer asks whether to back it up to `<path>.backup-<timestamp>` and replace it.
- **`--pretend` / `-p`:** Dry run. Prints the plan without changing anything.
- **`--force` / `-f`:** Replaces existing files without prompting and without backups.
- **`--copy`:** Copies files instead of symlinking them.
- **`--skip-plugins`:** Skips cloning the zsh plugins.
- **Per-machine overrides:** Put machine-specific settings and secrets in `~/.localrc`. `zshrc` sources it after everything else in the repo. It is not tracked.

## Dependencies

- **Required:** git, host, whois
  - macOS: included with the OS.
  - Debian/Ubuntu: `sudo apt-get install git host whois`
- **Optional:**
  - **eza:** Colored `ll` listings. `ll` falls back to plain `ls` when eza is missing.
    - macOS: `brew install eza`
    - Debian 13+ / Ubuntu 24.04+: `sudo apt install eza`. Older distros ship an eza that rejects `--color-scale=age`; install from https://github.com/eza-community/eza/releases instead.
  - **zsh-autosuggestions, zsh-syntax-highlighting:** Cloned into `~/.zsh-plugins` by `install.py`. `zshrc` skips each one when it is missing.
  - **Homebrew (macOS):** `zshrc` loads it from `/opt/homebrew` or `/usr/local` when present.
  - **pyenv:** `zshrc` initializes it when `~/.pyenv` exists.
  - **rmate:** Needed for the `subl` alias.

## Highlights

- **`ll`:** Long listing of all files, oldest first, so the most recently edited file is at the bottom. Uses eza with:
  - dates shaded from dark teal (oldest) to bright cyan (newest)
  - bold light-blue directories
  - a git status column inside repositories
  - colors set by `EZA_COLORS` and `EZA_MIN_LUMINANCE` in `zsh/config.zsh`
- **`ls` colors:** Directories are bold cyan (`LSCOLORS` in `zsh/config.zsh`, macOS `ls` only).
- **Prompt:** Shows the hostname when connected over SSH, plus git branch info.
- **tmux prefix:** `C-p` instead of `C-b`. `prefix P` opens the paste-buffer chooser, and `prefix p` keeps its default (previous window).
- **tmux:** vi copy-mode keys and mouse support.
- **tmux status bar:** SSH client latency, load averages, then date and time.
  - Latency comes from `bin/ssh-latency.sh` (installed as `~/.bin/ssh-latency.sh`), which works on macOS and Linux.
  - Load averages come from `/proc/loadavg` on Linux and `sysctl -n vm.loadavg` on macOS.
- **tmux sessions:** `personal` and `work` attach to (or create) tmux sessions with those names.
- **`subl`:** Alias for `rmate`, which opens remote files in Sublime Text on the client machine over SSH.
- **`sl`:** Alias for `ls`, for the common typo.
