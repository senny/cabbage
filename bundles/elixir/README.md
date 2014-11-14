# elixir bundle

The elixir bundle configures emacs for
[elixir](http://www.elixir-lang.org/) development.

## Features

* Configures elixir files to use the emacs [elixir-mode](https://github.com/elixir-lang/emacs-elixir).

* Adds elixir tooling functionality throught [alchemist-mode](https://github.com/tonini/alchemist.el) (mix,
  execute/compile, inline documentation)

* Elixir `_test.exs` files can be run with the `M-e` key-binding, witch calls
  `alchemist-mix-test-file` for the current buffer file.
