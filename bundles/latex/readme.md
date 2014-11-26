# latex bundle

Configures emacs for coding LaTeX.

## Features

* Adds bindings for converting a LaTeX file to a PDF and display it.

## Configuration options

# Functions / bindings

* `cabbage-latex-pdflatex-build` (`C-c 1`): convert the current LaTeX
  buffer into a PDF using `pdflatex`.

* `cabbage-latex-pdflatex-build-nonstop` (`C-c C-1`): convert the
  current LaTeX buffer into a PDF using `pdflatex` in nonstop mode.

* `cabbage-latex-open-pdf` (`C-c 2`): open the PDF (created created with
  `C-c 1`) using the `open` executable.

* `cabbage-latex-cleanup` (`C-c 3`): remove all temporary files (.aux,
  .lof, .log, .lot, .toc) and PDFs from the current working directory.
