(defcustom e-max-bundle-dir
  (concat e-max-repository "bundles/")
  "directory where the e-max bundles are located"
  :type 'string
  :group 'e-max)

(defcustom e-max-use-flymake t
  "set if you want to use flymake or not"
  :type 'boolean
  :group 'e-max)

(defcustom e-max-insert-pairs t
  "set if you want to insert double charatcters when appropriate"
  :type 'boolean
  :group 'e-max)

(defun e-max-bundle-active-p (bundle-name)
  (member bundle-name e-max-bundles))

(defun e-max-flymake-active-p ()
  e-max-use-flymake)

(defun e-max-insert-pairs-p ()
  e-max-insert-pairs)
