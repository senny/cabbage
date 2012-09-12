(defun cabbage-erc ()
  "Start erc in a seperate perspective."
  (interactive)
  (require 'erc)

  (cabbage-persp "@irc")
  (unless erc-server-connected
    (if (erc-server-buffer)
        (erc-cmd-RECONNECT)
      (call-interactively 'erc))))
