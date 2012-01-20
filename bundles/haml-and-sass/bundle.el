(e-max-vendor 'haml-mode)
(e-max-vendor 'sass-mode)
(e-max-vendor 'scss-mode)

(setq scss-compile-at-save nil)

(defun e-max-haml-mode-hook ()
  (e-max--set-pairs '("(" "{" "[" "\"" "\'" "|")))

(add-hook 'haml-mode-hook 'e-max-haml-mode-hook)

