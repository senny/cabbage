## Overview

e-max helps you to manage your emacs configuration and allows you to stay in sync with other fellow emacs users. It is designed to be a community-driven framework to build your emacs configuration. The ultimate goal of e-max is to provide a hassle-free, fast and robust emacs setup.

## Requirements

We want to get e-max working under as many different circumstances as possible. We are aiming to make the configuration as platform-/emacs-version independent as possible. So all you need to use e-max is Emacs.

## Install

### Automatic installer

    $ bash < <(curl -s https://raw.github.com/senny/e-max/master/scripts/install.sh)

### Developer installation

    $ git clone https://github.com/senny/e-max.git
    $ cd e-max
    $ ./scripts/install.sh

### Installation on Windows

1. You need to have emacs and git installed
2. Clone the e-max repository with git:
    ``git clone https://github.com/senny/e-max.git``
3. Pull down the submodules: cd the e-max directory, then run ``git submodule init && git submodule update``
4. Create a .emacs.d directory in your %HOME% folder
5. Copy the file templates/init.el from e-max to %HOME%/.emacs.d/init.el
6. Replace "E-MAX-DIR/" in the init.el with the path to the e-max checkout
7. If you are familiar with batch scripts, please write us a install.bat which does that ;-)

## Bundles

e-max fundamental organization are bundles. You can eneable and disable the configuration on a per bundle basis.
The bundles live in e-max/bundles. The active bundles are configured in your ~/.emacs.d/init.el file in the `e-max-bundles` variable.
The following bundles are supported currently:

* ergonomic (use ergonomic keybindings to use emacs more efficently)
* accessibility (make emacs behave the way you expect it and get distractions out of the way)
* git (git handling with magit)
* lisp (to write elisp)
* python (to write python)
* projects (simple projects management stuff)

### Your Bundles are welcome too!

if you got a peace of emacs functionality, that you think might be usefull for other people, please package it up in a bundle and open a
pull-request.

## Contributing

The project is under active development and we are always looking for assistance.

1. Fork e-max
2. Create a topic branch - `git checkout -b my_branch`
3. Make your changes and update the History.txt file
4. Push to your branch - `git push origin my_branch`
5. Send me a pull-request for your topic branch
6. That's it!
