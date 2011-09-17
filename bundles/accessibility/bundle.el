(defalias 'yes-or-no-p 'y-or-n-p)

(defun increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height))))
  (restore-frame)
  (maximize-frame))

(defun decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                (face-attribute 'default :height))))
  (restore-frame)
  (maximize-frame))

(global-set-key (kbd "<f5>") 'ns-toggle-fullscreen)
(global-set-key (kbd "C-+") 'increase-font-size)
(global-set-key (kbd "C-_") 'decrease-font-size)
