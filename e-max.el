(defcustom e-max-repository
  (expand-file-name "~/.e-max/")
  "The location of the e-max repository you want to use"
  :group 'e-max
  :type 'string)

(dolist (bundle e-max-bundles)
  (load (concat e-max-repository "bundles/" (symbol-name bundle) "/bundle.el")))
