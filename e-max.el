(require 'cl)

(if (not custom-file)
    (setq custom-file (expand-file-name "~/.emacs.d/custom.el")))
(load custom-file 'noerror)

(add-to-list 'load-path e-max-repository)

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

(dolist (bundle e-max-bundles)
  (load (concat e-max-bundle-dir (symbol-name bundle) "/bundle")))

;; TODO: load this earlier and debug the weird error
(load (concat e-max-repository "lib/themes"))

(run-hooks 'e-max-initialized-hook)
