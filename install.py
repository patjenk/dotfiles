import argparse
import filecmp
import os
import shutil


parser = argparse.ArgumentParser(description="Install the dotfiles into the current accounts home directory.")
parser.add_argument("action",
                    action="store")
parser.add_argument("-p", "--pretend",
                    action="store_true",
                    default=False,
                    dest="pretend",
                    help="print what install will do without doing it.")
parser.add_argument("-f", "--force",
                    action="store_true",
                    default=False,
                    dest="force",
                    help="force the installation of these dotfiles. overwrite all current dotfiles blindly.")
args = parser.parse_args()

try:
    input = raw_input
except:
    pass

def install(pretend, force):
    """
    Do the install stuff for my dotfiles.

    check to see if the dotfile already exists in our home directory.
    if so, check to see if it's identical
    if not, ask if we want to overwrite it.

    if it's a directory just link it or overwrite it. Don't attempt to
    do anything smart and look into the directory.
    """
    for filename in os.listdir("."):
        if filename in ["Rakefile", "README.markdown", "LICENSE", "install.py"]:
            continue
        if filename.startswith("."):
            continue

        full_filename = os.path.realpath(os.path.join(".", filename))

        dot_filename = os.path.expanduser(os.path.join("~",".{filename}".format(filename=filename)))
        if os.path.isfile(full_filename) :
            if os.path.isfile(dot_filename) or os.path.islink(dot_filename):
                if (os.path.islink(dot_filename) and os.path.samefile(filename, os.readlink(dot_filename))) or (os.path.isfile(dot_filename) and filecmp.cmp(full_filename, dot_filename)):
                    print("identical file: {filename} and {dot_filename}".format(filename=full_filename, dot_filename=dot_filename))
                else:
                    overwrite_choice = ""
                    while overwrite_choice not in ["y", "n"]:
                        if not force:
                            overwrite_choice = input("overwrite {filename} [y/n]? ".format(filename=dot_filename))
                        else:
                            overwrite_choice = "y"
                        if overwrite_choice == "y":
                            if not pretend:
                                os.remove(dot_filename)
                                os.symlink(full_filename, dot_filename)
                            print("replaced file: {dot_filename}".format(dot_filename=dot_filename))
                        elif overwrite_choice == "n":
                            print("skipped file: {dot_filename}".format(dot_filename=dot_filename))
            else:
                # the file doesn't exist, create it!
                if not pretend:
                    os.symlink(full_filename, dot_filename)
                print("linked file: {dot_filename}".format(dot_filename=dot_filename))
        elif os.path.isdir(full_filename):
            if os.path.isdir(dot_filename) or os.path.islink(dot_filename):
                if os.path.islink(dot_filename) and os.readlink(dot_filename) == full_filename:
                    print("identical directory: {filename} and {dot_filename}".format(filename=filename, dot_filename=dot_filename))
                else:
                    overwrite_choice = ""
                    while overwrite_choice not in ["y", "n"]:
                        if not force:
                            overwrite_choice = input("overwrite {filename} [y/n]? ".format(filename=dot_filename))
                        else:
                            overwrite_choice = "y"
                        if overwrite_choice == "y":
                            if not pretend:
                                shutil.rmtree(dot_filename)
                                os.symlink(full_filename, dot_filename)
                            print("replaced directory: {dot_filename}".format(dot_filename=dot_filename))
                        elif overwrite_choice == "n":
                            print("skipped directory: {dot_filename}".format(dot_filename=dot_filename))
            else:
                # the file doesn't exist, create it!
                if not pretend:
                    os.symlink(full_filename, dot_filename)
                print("linked directory: {dot_filename}".format(dot_filename=dot_filename))
        else:
            raise Exception("Unknown file {filename=filename}".format(filename=full_filename))
    pass


if __name__ == "__main__":
    if "install" == args.action:
        pretend = args.pretend
        force = args.force
        install(pretend=pretend, force=force)
    else:
        parser.print_help()
        parser.exit(1)
