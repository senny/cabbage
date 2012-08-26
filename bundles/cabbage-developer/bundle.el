(defun cabbage-emdeveloper-find-cabbage-config ()
  "Find-file in cabbage repository, openeing a new perspective @cabbage"
  (interactive)

  (cabbage-persp "@cabbage")
  (find-file (cabbage-ido-open-find-directory-files cabbage-repository)))

(defun cabbage-emdeveloper-emacs-persp ()
  "Opens the cabbage perspective."
  (interactive)
  (cabbage-persp "@cabbage"))

(global-set-key (kbd "C-c p") 'cabbage-emdeveloper-find-cabbage-config)
(global-set-key (kbd "C-p e") 'cabbage-emdeveloper-emacs-persp)
