# plone bundle

The plone bundle is useful when developing
[plone](http://www.plone.org/) based websites and applications,
especially when using
[zc.buildout](http://pypi.python.org/pypi/zc.buildout).

## Features

* Configures modes for .zcml, .?pt and .po[t] files.
* Configures flymake (pyflakes, xml-startlet)
* Provides shortcuts for finding files when using buildout.
* Configures pdb-mode, so that zope can be run within emacs.
* Reload code using
  [plone.reload](http://pypi.python.org/pypi/plone.reload).
* Provides snippets using yasnippet.

## Configuration options

* `cabbage-plone-enable-po-mode` if `t` (default), the
  [po-mode](http://www.gnu.org/software/gettext/manual/html_node/PO-Mode.html)
  is enabled for `.po` and `.pot` files.

* `cabbage-plone-known-buildout-instances`: A list of buildout scripts
  and their default arguments for starting zope within emacs in
  pdb-mode (using `cabbage-plone-run`). Defaults:

          '(("bin/instance" "fg")
            ("bin/instance1" "fg")
            ("bin/instanceadm" "fg")
            ("bin/serve" ""))

* `cabbage-plone-known-buildout-test-scripts`: A list of buildout
  scripts and ther default arguments for running tests within emacs
  (using `cabbage-plone-tests`). Defaults:

          '(("bin/test" "")
            ("bin/nose" "")
            ("bin/freshen" ""))

* `cabbage-plone-run-in-perspective`: If `t`, runs plone instances and
  tests in a seperate perspective. Defaults to `t`.

* `cabbage-plone-changelog-name`: When using
  `cabbage-plone-find-changelog-make-entry`, the here configured name
  will be used. If `nil`, the user login-name is used (default).

* `cabbage-plone-buildout--use-local-pep8`: Set to `t` when you have
  a `bin/pep8` in your buildout.

* `cabbage-plone-buildout--default-zope-user` Change the default
  username for connecting to Zope.


## Functions

WARNING: the here defined key bindings may change in the upcoming
binding refactoring.

* `cabbage-plone-ido-find-buildout` (`C-p b`): Open a buildout in a new
  perspective. First, choose the project-directory, then the
  buildout-directory, then the package, then the file. See the
  buildout layout section.

* `cabbage-plone-find-file-in-package` (`M-T`): Open a file in another
  package of the same buildout.

* `cabbage-plone-find-changelog-make-entry` (`C-c f c`): Find the
  `HISTORY.txt` of the current package and add a changelog entry.

* `cabbage-plone-run` (`C-c f f`): Run the zope instance in foreground
  mode. The buildout is searched relative to the current buffer.

* `cabbage-plone-tests` (`C-c f t`): Run tests by using the buildout
  script.

* `cabbage-plone-reload-code`: Reload the python code in a running zope
  instance where plone.reload is installed. The instance does not need
  to be running within emacs. This method does not use the
  `cabbage-plone-buildout--default-zope-user` option.
  Options:
  * `-c`: Reload only code (default)
  * `-z`: Reload code and zcml
  * `-u USER`: Zope username
  * `-p PASSWD`: Zope-user's password
  * `-H HOST`: Hostname (defaults to localhost)
  * `-P PORT`: Port (defaults to 8080)

* `cabbage-plone-goto-defition` (`C-M-<return>`): Find the definition of
  the symbol where the cursor is. If the line is a import statement,
  search the imported module using
  [omelette](http://pypi.python.org/pypi/collective.recipe.omelette/).

* `cabbage-plone-lookup-import` (`C-M-S-<return>`): Lookup a import
  using omelette. You can enter things like `Products.CMFCore.utils`
  or `from zope.interface import Interface`.

* `cabbage-plone--pep8-package` (`C-c f p`): Run pep8 for the current
  package. This needs `cabbage-plone-buildout--use-local-pep8` to be
  enabled.

* `cabbage-plone-find-adapter-by-name` (`C-c f a`): Find an adapter by
  its name by searching the component registry of the current
  zope instance. collective.z3cinspector needs to be installed on
  the zope instance.

* `cabbage-plone-find-adapter-by-providing-interface` (`C-c f A`):
  Find an adapter by the interface it provides by searching the
  component registry of the current zope instance.
  collective.z3cinspector needs to be installed on the zope instance.

* `cabbage-plone-find-utility-by-name` (`C-c f u`): Find a utility by
  its name by searching the component registry of the current
  zope instance. collective.z3cinspector needs to be installed on
  the zope instance.

* `cabbage-plone-find-utility-by-providing-interface` (`C-c f U`):
  Find an utility by the interface it provides by searching the
  component registry of the current zope instance.
  collective.z3cinspector needs to be installed on the zope instance.

## Buildout layout

For everything to work fine, the plone-bundle expects this directory
structure:

    * `cabbage-project-location`
    |
    |-- project-one/
    |   |
    |   |-- buildout1/
    |   |   |-- bin/
    |   |   |   |-- instance1
    |   |   |   `-- test
    |   |   |-- bootstrap.py
    |   |   |-- buildout.cfg
    |   |   |-- parts/
    |   |   |   `-- omelette/
    |   |   `-- src/
    |   |       |-- my.app
    |   |       |   |-- bin/
    |   |       |   |   `-- test
    |   |       |   |-- setup.py
    |   |       |   |-- bootstrap.py
    |   |       |   |-- test.cfg
    |   |       |   `-- my/
    |   |       `-- my.theme
    |   |
    |   `-- buildout2/
    |       ...
    |
    `-- project-two/
        |
        |-- a-buildout/
        |
        `-- another-buildout/

`cabbage-project-location` defaults to "~/Projects/" (currently requires
`project`-bundle).


## Snippets

The bundles adds additional snippets for python buffers:

* `I`: Creates a zope interface class.
* `Izs`: Creates a zope schema interface class.
* `zope.schema` fields:
 * `schema.Bool`
 * `schema.Choice`
 * `schema.Date`
 * `schema.Int`
 * `schema.List`
 * `schema.Text`
 * `schema.TextLine`
* `description`: Creates a translated description (use within a
  zope.schema field definition).
* `label`: Creates a translated label.
* `title`: Creates a translated title.
