(setq feature-default-i18n-file (concat e-max-vendor-dir "feature-mode/i18n.yml"))
(setq feature-cucumber-command "bundle exec cucumber {feature}")

(e-max-vendor 'feature-mode)

(defun e-max-cucumber-run-single-file (file-name)
  (when (e-max-bundle-active-p 'ruby)
    (rvm-activate-corresponding-ruby))
  (feature-run-cucumber '() :feature-file file-name))

(defun e-max-cucumber-hook ()
  (setq e-max-testing-execute-function 'e-max-cucumber-run-single-file)

  (e-max--set-pairs '("(" "\"" "\'")))

(add-hook 'feature-mode-hook 'e-max-cucumber-hook)
