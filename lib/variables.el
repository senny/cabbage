(defcustom cabbage-bundle-dir
  (concat cabbage-repository "bundles/")
  "directory where the cabbage bundles are located"
  :type 'string
  :group 'cabbage)

(defcustom cabbage-vendor-dir
  (concat cabbage-repository "vendor/")
  "directory where the cabbage vendored libraries are located"
  :type 'string
  :group 'cabbage)

(defcustom cabbage-use-flymake t
  "set if you want to use flymake or not"
  :type 'boolean
  :group 'cabbage)

(defcustom cabbage-insert-pairs t
  "set if you want to insert double charatcters when appropriate"
  :type 'boolean
  :group 'cabbage)
