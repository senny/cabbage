(defvar e-max-bindings-themes-directory
  (concat e-max-repository "lib/bindings/themes")
  "Location where e-max binding themes are stored")

(load (concat e-max-repository "lib/bindings/framework"))

(if (file-exists-p e-max-bindings-themes-directory)
    (mapc #'load (directory-files e-max-bindings-themes-directory t ".*elc?$")))

(when e-max-binding-theme
 (e-max-bindings-activate e-max-binding-theme))
