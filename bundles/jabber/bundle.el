
(defun e-max-jabber ()
  "Open jabber in the @Jabber perspective."
  (interactive)
  (add-to-list 'load-path (concat e-max-repository "vendor/emacs-jabber"))
  (require 'jabber)

  (e-max-persp "@Jabber")
  (jabber-connect-all)
  (when (not (equal (substring (buffer-name) 0 8) "*-jabber"))
    (call-interactively 'jabber-display-roster)
    (switch-to-buffer jabber-roster-buffer)))

(e-max-global-set-key (kbd "C-p j") 'e-max-jabber)
