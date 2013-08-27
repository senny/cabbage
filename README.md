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

### Installation on Windows (PowerShell)

If you don't yet have PowerShell; it is part of the Windows Management Framework and you can get it from the Microsoft download center: [Windows Management Framework 3.0](http://www.microsoft.com/en-us/download/details.aspx?id=34595)

All tested and developed with GNU Emacs 24.1.1 from http://ftp.gnu.org/gnu/emacs/windows/.
If you're using another Emacs version under windows, your configuration directories might not match.
If this is the case, please report the issue and we will try to fix it.

#### Automatic installation

    > (new-object Net.WebClient).DownloadString("https://raw.github.com/senny/cabbage/master/scripts/install.ps1") | iex

#### Developer installation

	> git clone https://github.com/senny/cabbage.git
	> cd cabbage
	> ./scripts/install.ps1

#### Updating an existing installation

1. Go to your cabbage directory
2. Execute the installation script again

```
./scripts/install.ps1
```

### Manual installation on Windows

Seriously, if you're not using PowerShell under Windows, you're probably doing it wrong. Here are however the manual installation instructions.

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
Check out the [bundles directory](https://github.com/senny/cabbage/tree/master/bundles) to see whats currently available.

### Your Bundles are welcome too!

if you got a pice of emacs functionality, that you think might be usefull for other people, please package it up in a bundle and open a
pull-request.

### Local bundles

It also to create private / local bundles if something does not belong
into the cabbage core. It is quite easy:

- Create a local bundles directory, e.g. `~/.emacs.d/bundles`
- Create your bundle, for example
  `~/.emacs.d/bundles/secret-stuff/bundle.el`
- Register the bundles directory at the top of your `~/.emacs.d/local.el` by adding this line:

      (add-to-list 'cabbage-bundle-dirs (expand-file-name "~/.emacs.d/bundles/"))

- Add `secret-stuff` to your bundles list in `~/.emacs.d/config.el`
- You can also create a local vendors directory and
  register it with:

      (add-to-list 'cabbage-vendor-dirs (expand-file-name "~/.emacs.d/vendor/"))

- Take a look on how the existing bundles work.

### Cheat Sheet

There is a [cheat-sheet](misc/cheat-sheet.pdf) available for the default keyboard
shortcuts that come with cabbage.

### Contributions

If you are interested in helping out, please have a look at our [Contribution Guidelines](https://github.com/senny/cabbage/blob/master/CONTRIBUTING.md).

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/63a56e02597deaf55327bc0dd26638c6 "githalytics.com")](http://githalytics.com/senny/cabbage)
