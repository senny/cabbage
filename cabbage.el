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

(load (concat cabbage-repository "lib/variables"))
(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p local-config) (load local-config) )

(add-to-list 'load-path cabbage-repository)

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

(when (and (not custom-enabled-themes)
           (not (cabbage-bundle-active-p 'theme-roller)))
  (warn "deprecation warning:
Since Emacs version 24 the `deftheme` macro has become sophisticated.
The `theme-roller` package, which ships with cabbage, is no longer a hard dependency.
Moving forward, you can use either `theme-roller` or the `deftheme` macro.

* To keep the current behavior, add `theme-roller` to your bundle list in `config.el`.
* To use a theme provided by `deftheme` simply call `load-theme` from your personal configuration.")
  (cabbage-load-bundle 'theme-roller))

(run-hooks 'cabbage-initialized-hook)
