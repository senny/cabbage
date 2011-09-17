(load (concat e-max-repository "lib/bundles"))
(load (concat e-max-repository "lib/defun"))

(dolist (bundle e-max-bundles)
  (load (concat e-max-repository "bundles/" (symbol-name bundle) "/bundle")))
