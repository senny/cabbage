(require 'cl)

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

(if (file-exists-p local-config) (load local-config) )
(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))

(add-to-list 'load-path e-max-repository)

(load (concat e-max-repository "lib/variables"))
(load (concat e-max-repository "lib/bundles"))
(load (concat e-max-repository "lib/defun"))
(load (concat e-max-repository "lib/perspective"))
(load (concat e-max-repository "lib/compilation"))
(load (concat e-max-repository "lib/setup"))

(cond
 ((string-match "nt" system-configuration)
  (load "lib/platforms/windows"))
 ((string-match "apple" system-configuration)
  (load "lib/platforms/mac")))

(run-hooks 'e-max-pre-bundle-hook)

(dolist (bundle e-max-bundles)
  (load (concat e-max-bundle-dir (symbol-name bundle) "/bundle")))

;; TODO: load this earlier and debug the weird error
(load (concat e-max-repository "lib/themes"))

(run-hooks 'e-max-initialized-hook)
