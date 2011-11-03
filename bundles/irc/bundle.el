
(defun e-max-erc ()
  "Start erc in a seperate perspective."
  (interactive)
  (require 'erc)

  (e-max-persp "@irc")
  (unless erc-server-connected
    (if (erc-server-buffer)
        (erc-cmd-RECONNECT)
      (call-interactively 'erc))))

(e-max-global-set-key (kbd "C-p i") 'e-max-erc)
