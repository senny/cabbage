# python bundle

The python bundle configures emacs for
[python](http://www.python.org/) development.


## Features

* Configures python files to use the emacs built-in `python-mode`.

* Configures [flymake](http://flymake.sourceforge.net/) to use
  [pyflakes](https://launchpad.net/pyflakes).

* Shortcut for [pep8](http://www.python.org/dev/peps/pep-0008/) check.

* Shortcut for [pylint](http://pypi.python.org/pypi/pylint) check.

* Configure [yasnippet](http://code.google.com/p/yasnippet/) snippets.

* Configures emacs to use 4 spaces for indenting in python buffers.


# Configuration options

* `cabbage-python-pyflakes-enabled`: if `t` and there is a `pyflakes`
  executable somewhere in `PATH` it enables flymake for python files
  using pyflakes. There is also a global `cabbage-use-flymake`
  configuration.


# Functions

* `cabbage-python-pep8` (`C-°`): Validate the current buffer with pep8
  and display a grep-like buffer with errors.

* `cabbage-python-pylint` (`C-M-§`): Validate the current buffer with
  pylint and display a grep-like buffer with errors.


# Snippets

Type the snippet name and press `TAB` in a python buffer.

* `class`: Create an advanced python class.
* `cls`: Create a simple python class.
* `def`: Create a function.
* `for`: Create a for-loop.
* `if`: Create an if-statement.
* `pdb`: Import pdb and set a breakpoint.
* `while`: Create a while-loop.
