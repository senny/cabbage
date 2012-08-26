(cabbage-vendor 'perspective)

(defmacro cabbage-persp (name &rest body)
  `(let ((initialize (not (gethash ,name perspectives-hash))))
     (persp-switch ,name)
     (when initialize ,@body)))

(defun cabbage-persp-last ()
  (interactive)
  (persp-switch (persp-name persp-last)))

(defun persp-format-name (name)
  "Format the perspective name given by NAME for display in `persp-modestring'."
  (let ((string-name (format "%s" name)))
    (if (equal name (persp-name persp-curr))
        (propertize string-name 'face 'persp-selected-face))))

(defun cabbage-persp-main ()
  (interactive)
  (cabbage-persp "main"))

(defun persp-update-modestring ()
  "Update `persp-modestring' to reflect the current perspectives.
Has no effect when `persp-show-modestring' is nil."
  (when persp-show-modestring
    (setq persp-modestring
          (append '("[")
                  (persp-intersperse (mapcar 'persp-format-name (persp-names)) "")
                  '("]")))))

(defun cabbage-perspective-bindings ()
  (when (cabbage-bundle-active-p 'ergonomic)
    (global-set-key (kbd "C-p s") 'persp-switch)
    (global-set-key (kbd "C-p p") 'cabbage-persp-last)
    (global-set-key (kbd "C-p d") 'persp-kill)
    (global-set-key (kbd "C-p x") 'persp-kill)
    (global-set-key (kbd "C-p m") 'cabbage-persp-main)))

(add-hook 'cabbage-initialized-hook 'cabbage-perspective-bindings)

(persp-mode)
