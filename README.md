```shell

                                      $$\       $$\
                                      $$ |      $$ |
                   $$$$$$$\  $$$$$$\  $$$$$$$\  $$$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\
                  $$  _____| \____$$\ $$  __$$\ $$  __$$\  \____$$\ $$  __$$\ $$  __$$\
                  $$ /       $$$$$$$ |$$ |  $$ |$$ |  $$ | $$$$$$$ |$$ /  $$ |$$$$$$$$ |
                  $$ |      $$  __$$ |$$ |  $$ |$$ |  $$ |$$  __$$ |$$ |  $$ |$$   ____|
                  \$$$$$$$\ \$$$$$$$ |$$$$$$$  |$$$$$$$  |\$$$$$$$ |\$$$$$$$ |\$$$$$$$\
                   \_______| \_______|\_______/ \_______/  \_______| \____$$ | \_______|
                                                                    $$\   $$ |
                                                                    \$$$$$$  |
                                                                     \______/
```


## Overview

cabbage helps you to manage your emacs configuration and allows you to stay in sync with other fellow emacs users. It is designed to be a community-driven framework to build your emacs configuration. The ultimate goal of cabbage is to provide a hassle-free, fast and robust emacs setup.

=> [Google Group](https://groups.google.com/forum/#!forum/emacs-cabbage)

## Requirements

We want to get cabbage working under as many different circumstances as possible. We are aiming to make the configuration as platform-/emacs-version independent as possible. So all you need to use cabbage is Emacs.

## Install

### Automatic installer

    $ /usr/bin/env bash -c "$(curl -fsSL https://raw.github.com/senny/cabbage/master/scripts/install.sh)"

### Developer installation

    $ git clone https://github.com/senny/cabbage.git
    $ cd cabbage
    $ ./scripts/install.sh

### Installation on Windows

All tested and developed with GNU Emacs 24.1.1 from http://ftp.gnu.org/gnu/emacs/windows/.
If you're using another Emacs version under windows, your configuration directories might not match.
If this is the case, please report the issue and we will try to fix it.

#### Using PowerShell

    > (new-object Net.WebClient).DownloadString("https://raw.github.com/senny/cabbage/master/scripts/install.ps1") | iex

#### Developer install with PowerShell

	> git clone https://github.com/senny/cabbage.git
	> cd cabbage
	> ./scripts/install.ps1

#### Without PowerShell

Seriously, if you're not using PowerShell under Windows, you're probably doing it wrong. Here is however the manual installation instruction.

1. You need to have emacs and git installed
2. Clone the cabbage repository with git:
    ``git clone https://github.com/senny/cabbage.git``
3. Pull down the submodules: cd the cabbage directory, then run ``git submodule init && git submodule update``
4. Create a .emacs.d directory in your %APPDATA% folder
5. Copy the file templates/init.el from cabbage to %APPDATA%/.emacs.d/init.el
6. Replace "CABBAGE-DIR/" in the init.el with the path to the cabbage checkout
7. Copy the contents of the templates/emacs.d directory to your %APPDATA%/.emacs.d directory

## Bundles

cabbage fundamental organization are bundles. You can eneable and disable the configuration on a per bundle basis.
The bundles live in cabbage/bundles. The active bundles are configured in your ~/.emacs.d/config.el file in the `cabbage-bundles` variable.
The following bundles are supported currently:

* ergonomic (use ergonomic keybindings to use emacs more efficently)
* accessibility (make emacs behave the way you expect it and get distractions out of the way)
* git (git handling with magit)
* lisp (to write elisp)
* python (to write python)
* projects (simple projects management stuff)

### Your Bundles are welcome too!

if you got a pice of emacs functionality, that you think might be usefull for other people, please package it up in a bundle and open a
pull-request.

## Contributing

The project is under active development and we are always looking for assistance.

1. Fork cabbage
2. Create a topic branch - `git checkout -b my_branch`
3. Make your changes and update the History.txt file
4. Push to your branch - `git push origin my_branch`
5. Send me a pull-request for your topic branch
6. That's it!
