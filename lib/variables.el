(defcustom cabbage-bundle-dirs
  (list (concat cabbage-repository "bundles/"))
  "directories where the cabbage bundles are located"
  :type 'list
  :group 'cabbage)

(defcustom cabbage-vendor-dirs
  (list (concat cabbage-repository "vendor/"))
  "directories where the cabbage vendored libraries are located"
  :type 'string
  :group 'cabbage)

(defcustom cabbage-use-flycheck t
  "set if you want to use flycheck or not"
  :type 'boolean
  :group 'cabbage)

(defcustom cabbage-insert-pairs t
  "set if you want to insert double charatcters when appropriate"
  :type 'boolean
  :group 'cabbage)
