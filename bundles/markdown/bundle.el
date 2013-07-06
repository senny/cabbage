(cabbage-vendor 'markdown-mode)

(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mkd$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mkdn$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdwn$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text$" . markdown-mode))

(defun cabbage-markdown-mode-hook ()
  (setq fill-column 80)
  (cabbage--set-pairs '("(" "{" "[" "\""))
  (auto-fill-mode 1))

(add-hook 'markdown-mode-hook 'cabbage-markdown-mode-hook)
