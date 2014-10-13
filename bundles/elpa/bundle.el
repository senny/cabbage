(if (< emacs-major-version 24)
    (progn
      (cabbage-vendor 'package)
      (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
  (require 'package))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)
