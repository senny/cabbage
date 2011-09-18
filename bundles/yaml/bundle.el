(e-max-vendor 'yaml-mode)

(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

;; Hooks
(defun e-max-yaml-hook ()
  (e-max--set-pairs '("(" "\"" "\'" "{")))

(add-hook 'yaml-mode-hook 'e-max-yaml-hook)
