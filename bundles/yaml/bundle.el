(cabbage-vendor 'yaml-mode)

(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;; Hooks
(defun cabbage-yaml-hook ()
  (cabbage--set-pairs '("(" "\"" "\'" "{")))

(add-hook 'yaml-mode-hook 'cabbage-yaml-hook)
