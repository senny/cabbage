(setq feature-default-i18n-file (concat cabbage-vendor-dir "feature-mode/i18n.yml"))
(setq feature-cucumber-command "bundle exec cucumber {feature}")

(cabbage-vendor 'feature-mode)

(defun cabbage-cucumber-run-single-file (file-name)
  (when (cabbage-bundle-active-p 'ruby)
    (rvm-activate-corresponding-ruby))
  (feature-run-cucumber '() :feature-file file-name))

(defun cabbage-cucumber-hook ()
  (setq cabbage-testing-execute-function 'cabbage-cucumber-run-single-file)

  (cabbage--set-pairs '("(" "\"" "\'")))

(add-hook 'feature-mode-hook 'cabbage-cucumber-hook)
