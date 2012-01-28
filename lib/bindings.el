(defvar e-max-bindings-api-is-active nil
  "This variable holds the state if the binding-api is active or not")

(defvar e-max-bindings-registerd-themes '()
  "list of registered binding-theme names")

(defvar e-max-bindings-themes-directory
  (concat e-max-repository "lib/bindings/themes")
  "Location where e-max binding themes are stored")

(defun e-max-bindings-is-theme-p (theme)
  (member theme e-max-bindings-registerd-themes))

(defun e-max-bindings-is-active-p ()
  e-max-bindings-api-is-active)

(load (concat e-max-repository "lib/bindings/basic-framework"))

(if (file-exists-p e-max-bindings-themes-directory)
    (mapc #'load (directory-files e-max-bindings-themes-directory t ".*elc?$")))

(when e-max-binding-theme
 (e-max-bindings-activate e-max-binding-theme))
