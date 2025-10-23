#!/usr/bin/env python3
import argparse
import filecmp
import os
import shutil
import subprocess
import sys
import time

IGNORE = {
    "Rakefile",
    "README.markdown",
    "README.md",
    "LICENSE",
    "install.py",
    ".git",
    ".gitmodules",
    ".DS_Store",
}

def abspath(path):
    return os.path.realpath(os.path.abspath(path))

def ensure_parent(path):
    parent = os.path.dirname(path)
    if parent and not os.path.exists(parent):
        os.makedirs(parent, exist_ok=True)

def is_identical_file(src, dst):
    """Return True if dst is a regular file identical to src by content."""
    return os.path.isfile(dst) and filecmp.cmp(src, dst, shallow=False)

def is_identical_link(src, dst):
    """Return True if dst is a symlink pointing (effectively) to src."""
    if not os.path.islink(dst):
        return False
    link_target = os.readlink(dst)
    # Resolve relative link target against the link's directory
    link_target_abs = abspath(os.path.join(os.path.dirname(dst), link_target))
    return abspath(src) == link_target_abs

def remove_path(path):
    """Remove file/dir/symlink at path safely."""
    if os.path.islink(path):
        os.unlink(path)
    elif os.path.isdir(path):
        shutil.rmtree(path)
    elif os.path.exists(path):
        os.remove(path)

def backup_path(path):
    ts = time.strftime("%Y%m%d-%H%M%S")
    return f"{path}.backup-{ts}"

def prompt_yes_no(msg):
    while True:
        ans = input(f"{msg} [y/n] ").strip().lower()
        if ans in ("y", "n"):
            return ans == "y"

def link_or_copy(src, dst, copy=False, pretend=False):
    ensure_parent(dst)
    if pretend:
        print(f"PLAN: {'copy' if copy else 'link'} -> {dst}  (from {src})")
        return
    if copy:
        if os.path.isdir(src):
            shutil.copytree(src, dst, symlinks=True)
        else:
            shutil.copy2(src, dst)
    else:
        os.symlink(src, dst)
    print(f"{'copied' if copy else 'linked'}: {dst}")

def install(pretend, force, copy=False):
    repo_root = os.getcwd()
    for entry in os.listdir(repo_root):
        if entry in IGNORE or entry.startswith("."):
            # We only install *non-dot* names as ~/.name
            continue

        src = abspath(os.path.join(repo_root, entry))
        dst = os.path.expanduser(os.path.join("~", f".{entry}"))

        if os.path.isfile(src):
            # FILE
            if os.path.exists(dst) or os.path.islink(dst):
                if is_identical_link(src, dst) or is_identical_file(src, dst):
                    print(f"identical file: {dst}")
                    continue

                if force:
                    if not pretend:
                        remove_path(dst)
                        link_or_copy(src, dst, copy=copy, pretend=False)
                    else:
                        print(f"PLAN: replace file {dst}")
                    continue

                # No force: offer backup or skip
                print(f"conflict: {dst} exists and differs")
                if prompt_yes_no("Backup existing and replace?"):
                    if not pretend:
                        bkp = backup_path(dst)
                        os.rename(dst, bkp)
                        print(f"backed up: {bkp}")
                        link_or_copy(src, dst, copy=copy, pretend=False)
                    else:
                        print(f"PLAN: backup {dst} and replace")
                else:
                    print(f"skipped file: {dst}")
            else:
                link_or_copy(src, dst, copy=copy, pretend=pretend)

        elif os.path.isdir(src):
            # DIRECTORY
            if os.path.exists(dst) or os.path.islink(dst):
                if is_identical_link(src, dst):
                    print(f"identical directory link: {dst}")
                    continue
                if force:
                    if not pretend:
                        remove_path(dst)
                        link_or_copy(src, dst, copy=copy, pretend=False)
                    else:
                        print(f"PLAN: replace directory {dst}")
                    continue

                print(f"conflict: {dst} exists and differs")
                if prompt_yes_no("Backup existing and replace?"):
                    if not pretend:
                        bkp = backup_path(dst)
                        os.rename(dst, bkp)
                        print(f"backed up: {bkp}")
                        link_or_copy(src, dst, copy=copy, pretend=False)
                    else:
                        print(f"PLAN: backup {dst} and replace")
                else:
                    print(f"skipped directory: {dst}")
            else:
                link_or_copy(src, dst, copy=copy, pretend=pretend)

        else:
            print(f"warning: unknown path type, skipping: {src}")

def install_plugins():
    plugin_dir = os.path.expanduser("~/.zsh-plugins")
    os.makedirs(plugin_dir, exist_ok=True)

    plugins = {
        "zsh-autosuggestions": "https://github.com/zsh-users/zsh-autosuggestions",
        "zsh-syntax-highlighting": "https://github.com/zsh-users/zsh-syntax-highlighting"
    }

    for name, repo in plugins.items():
        path = os.path.join(plugin_dir, name)
        if not os.path.exists(path):
            print(f"Cloning {name}...")
            subprocess.run(["git", "clone", repo, path], check=True)
        else:
            print(f"{name} already installed, skipping.")

def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Install the dotfiles into the current account's home directory."
    )
    parser.add_argument("action", choices=["install"], help="Action to perform.")
    parser.add_argument("-p", "--pretend", action="store_true", help="Dry run.")
    parser.add_argument("-f", "--force", action="store_true",
                        help="Overwrite existing files/dirs without prompting (no backups).")
    parser.add_argument("--copy", action="store_true",
                        help="Copy files instead of creating symlinks.")
    args = parser.parse_args(argv)

    if args.action == "install":
        try:
            install(pretend=args.pretend, force=args.force, copy=args.copy)
            if not args.pretend and not args.skip_plugins:
                if shutil.which("git"):
                    install_plugins()
                else:
                    print("git not found in PATH; skipping plugin installation.")
        except KeyboardInterrupt:
            print("\naborted.")
            sys.exit(130)

if __name__ == "__main__":
    main()
