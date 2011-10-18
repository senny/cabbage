(e-max-vendor 'perspective)

(defmacro e-max-persp (name &rest body)
  `(let ((initialize (not (gethash ,name perspectives-hash))))
     (persp-switch ,name)
     (when initialize ,@body)))

(defun e-max-persp-last ()
  (interactive)
  (persp-switch (persp-name persp-last)))

(defun persp-format-name (name)
  "Format the perspective name given by NAME for display in `persp-modestring'."
  (let ((string-name (format "%s" name)))
    (if (equal name (persp-name persp-curr))
        (propertize string-name 'face 'persp-selected-face))))

(defun e-max-persp-main ()
  (interactive)
  (e-max-persp "main"))

(defun persp-update-modestring ()
  "Update `persp-modestring' to reflect the current perspectives.
Has no effect when `persp-show-modestring' is nil."
  (when persp-show-modestring
    (setq persp-modestring
          (append '("[")
                  (persp-intersperse (mapcar 'persp-format-name (persp-names)) "")
                  '("]")))))

(defun e-max-perspective-bindings ()
  (when (e-max-bundle-active-p 'ergonomic)
    (global-set-key (kbd "C-p s") 'persp-switch)
    (global-set-key (kbd "C-p p") 'e-max-persp-last)
    (global-set-key (kbd "C-p m") 'e-max-persp-main)))

(add-hook 'e-max-initialized-hook 'e-max-perspective-bindings)

(persp-mode)
