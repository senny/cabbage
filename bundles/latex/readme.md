# latex bundle

Configures emacs for coding LaTeX.


## Features

* Configures [flymake](http://flymake.sourceforge.net/) validation
  using [chktex](http://baruch.ev-en.org/proj/chktex/).

* Adds bindings for converting a LaTeX file to a PDF and display it.


## Configuration options

* `e-max-latex-enable-flymake`: If `t` (default), emacs will try to
  set up flymake validation.

* `e-max-latex-flymake-use-chktex`: If `t` (default), e-max
  reconfigures the flymake validation to use "chktex". The chktex
  executable has to be in the `PATH`. If it is `nil`, `texify` is
  used.


# Functions / bindings

* `e-max-latex-pdflatex-build` (`C-c 1`): convert the current LaTeX
  buffer into a PDF using `pdflatex`.

* `e-max-latex-pdflatex-build-nonstop` (`C-c C-1`): convert the
  current LaTeX buffer into a PDF using `pdflatex` in nonstop mode.

* `e-max-latex-open-pdf` (`C-c 2`): open the PDF (created created with
  `C-c 1`) using the `open` executable.

* `e-max-latex-cleanup` (`C-c 3`): remove all temporary files (.aux,
  .lof, .log, .lot, .toc) and PDFs from the current working directory.
