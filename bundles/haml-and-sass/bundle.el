(cabbage-vendor 'haml-mode)
(cabbage-vendor 'sass-mode)
(cabbage-vendor 'scss-mode)

(setq scss-compile-at-save nil)

(defun cabbage-haml-mode-hook ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "|")))

(add-hook 'haml-mode-hook 'cabbage-haml-mode-hook)

