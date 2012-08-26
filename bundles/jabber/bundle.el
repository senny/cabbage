
(defun cabbage-jabber ()
  "Open jabber in the @Jabber perspective."
  (interactive)
  (add-to-list 'load-path (concat cabbage-repository "vendor/emacs-jabber"))
  (require 'jabber)

  (cabbage-persp "@Jabber")
  (jabber-connect-all)
  (when (not (equal (substring (buffer-name) 0 8) "*-jabber"))
    (call-interactively 'jabber-display-roster)
    (switch-to-buffer jabber-roster-buffer)))

(cabbage-global-set-key (kbd "C-p j") 'cabbage-jabber)
