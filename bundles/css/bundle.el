;; File Mappings
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))


(defun e-max-css-set-pairs ()
  (e-max--set-pairs '("(" "[" "\"" "\'")))

(add-hook 'css-mode-hook 'e-max-css-set-pairs)


(defun e-max-css-set-indenting ()
  (setq css-indent-level 2)
  (setq css-indent-offset 2))

(add-hook 'css-mode-hook 'e-max-css-set-indenting)
