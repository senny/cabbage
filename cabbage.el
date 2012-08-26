(require 'cl)

(load (expand-file-name "~/.emacs.d/config.el") 'noerror)

(if (not custom-file)
    (setq custom-file (expand-file-name "~/.emacs.d/custom.el")))
(load custom-file 'noerror)

;; Platform-specific stuff
(when (eq system-type 'darwin)
  ;; Work around a bug on OS X where system-name is FQDN
  (setq system-name (car (split-string system-name "\\."))))

;; You can keep system- or user-specific customizations here
(setq local-config (expand-file-name "~/.emacs.d/local.el")
      system-specific-config (expand-file-name (concat "~/.emacs.d/machines/" system-name ".el"))
      user-specific-config (expand-file-name (concat"~/.emacs.d/users/" user-login-name ".el")))

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p local-config) (load local-config) )

(add-to-list 'load-path cabbage-repository)

(load (concat cabbage-repository "lib/variables"))
(load (concat cabbage-repository "lib/bundles/framework"))
(load (concat cabbage-repository "lib/defun"))
(load (concat cabbage-repository "lib/setup"))
(load (concat cabbage-repository "lib/perspective"))
(load (concat cabbage-repository "lib/compilation"))
(load (concat cabbage-repository "lib/modes"))

(cond
 ((string-match "nt" system-configuration)
  (load "lib/platforms/windows"))
 ((string-match "apple" system-configuration)
  (load "lib/platforms/mac")))

(run-hooks 'cabbage-pre-bundle-hook)

(dolist (bundle cabbage-bundles)
  (cabbage-load-bundle bundle))

;; TODO: load this earlier and debug the weird error
(load (concat cabbage-repository "lib/themes"))

(run-hooks 'cabbage-initialized-hook)
