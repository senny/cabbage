(setq feature-default-i18n-file (concat e-max-vendor-dir "feature-mode/i18n.yml"))

(e-max-vendor 'feature-mode)

(defun e-max-cucumber-hook ()
  (e-max--set-pairs '("(" "\"" "\'")))

(add-hook 'feature-mode-hook 'e-max-cucumber-hook)
