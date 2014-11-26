(cabbage-vendor 'flycheck)

(defun cabbage-flycheck-keybindings ()
  (local-set-key (kbd "C-c f n") 'flycheck-next-error)
  (local-set-key (kbd "C-c f p") 'flycheck-previous-error)
  (local-set-key (kbd "C-c f l") 'flycheck-list-errors))
