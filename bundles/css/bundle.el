;; File Mappings
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))


(defun cabbage-css-set-pairs ()
  (cabbage--set-pairs '("(" "[" "\"" "\'")))

(add-hook 'css-mode-hook 'cabbage-css-set-pairs)


(defun cabbage-css-set-indenting ()
  (setq css-indent-level 2)
  (setq css-indent-offset 2))

(add-hook 'css-mode-hook 'cabbage-css-set-indenting)
