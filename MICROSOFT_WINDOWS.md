## Installation on Windows (PowerShell)

If you don't yet have PowerShell; it is part of the Windows Management Framework and you can get it from the Microsoft download center: [Windows Management Framework 3.0](http://www.microsoft.com/en-us/download/details.aspx?id=34595)

All tested and developed with GNU Emacs 24.1.1 from http://ftp.gnu.org/gnu/emacs/windows/.
If you're using another Emacs version under windows, your configuration directories might not match.
If this is the case, please report the issue and we will try to fix it.

### Automatic installation

```shell
> (new-object Net.WebClient).DownloadString("https://raw.github.com/senny/cabbage/master/scripts/install.ps1") | iex
```

### Developer installation

```shell
> git clone https://github.com/senny/cabbage.git
> cd cabbage
> ./scripts/install.ps1
```
### Updating an existing installation

1. Go to your cabbage directory
2. Execute the installation script again

```shell
> ./scripts/install.ps1
```

## Manual installation on Windows

Seriously, if you're not using PowerShell under Windows, you're probably doing it wrong. Here are however the manual installation instructions.

1. You need to have emacs and git installed
2. Clone the cabbage repository with git:
    ``git clone https://github.com/senny/cabbage.git``
3. Pull down the submodules: cd the cabbage directory, then run ``git submodule init && git submodule update``
4. Create a `.emacs.d` directory in your `%APPDATA%` folder
5. Copy the file `templates/init.el` from cabbage to `%APPDATA%/.emacs.d/init.el`
6. Replace `"CABBAGE-DIR/"` in the `init.el` with the path to the cabbage checkout
7. Copy the contents of the `templates/emacs.d` directory to your `%APPDATA%/.emacs.d` directory
