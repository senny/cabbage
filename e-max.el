(add-to-list 'load-path e-max-repository)

(load (concat e-max-repository "lib/bundles"))
(load (concat e-max-repository "lib/defun"))
(load (concat e-max-repository "lib/perspective"))
(load (concat e-max-repository "lib/setup"))

(cond
 ((string-match "nt" system-configuration)
  (load "lib/platforms/windows"))
 ((string-match "apple" system-configuration)
  (load "lib/platforms/mac")))

(dolist (bundle e-max-bundles)
  (load (concat e-max-repository "bundles/" (symbol-name bundle) "/bundle")))
