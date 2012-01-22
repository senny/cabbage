(defvar e-max--globaly-bound-keys-alist '())

(defvar e-max-bindings-api-is-active nil
  "This variable holds the state if the binding-api is active or not")

(defvar e-max-bindings-themes-store (make-hash-table :test 'equal)
  "this variable holds the configuration data for every registered binding theme.")

(defvar e-max-bindings-registerd-themes '()
  "list of registered binding-theme names")

(defvar e-max-bindings-emulation-keymap nil
  "this keymap is used for 'sticky' bindings")

(defun e-max-bindings-deactivate ()
  (interactive)
  (when (e-max-bindings-is-active-p)
    (setq emulation-mode-map-alists (delq 'e-max-bindings-emulation-keymap emulation-mode-map-alists))
    (setq e-max-bindings-api-is-active nil)))

(defun e-max-bindings-activate (theme)
  (interactive
   (list (ido-completing-read "Ruby Version: " e-max-bindings-registerd-themes)))
  (when (not (e-max-bindings-is-theme-p theme))
    (error (concat "'" theme "'" "is not a valid binding-theme")))
  (when (not (e-max-bindings-is-active-p))
    (let* ((theme-keymap-store (gethash theme e-max-bindings-themes-store))
           (theme-global-keymap (gethash 'global-keymap theme-keymap-store)))
      (setq e-max-bindings-emulation-keymap `((t . ,theme-global-keymap)))
      (add-to-ordered-list 'emulation-mode-map-alists 'e-max-bindings-emulation-keymap 400)
      (setq e-max-bindings-api-is-active t))))

(defun e-max-bindings-is-theme-p (theme)
  (member theme e-max-bindings-registerd-themes))

(defun e-max-bindings-is-active-p ()
  e-max-bindings-api-is-active)

(defmacro* e-max-bindings-make-theme (name &rest body)
  (add-to-list 'e-max-bindings-registerd-themes name)
  `(let* ((theme-keymap-store (puthash ,name (make-hash-table :test 'equal) e-max-bindings-themes-store ))
          (theme-global-keymap (puthash 'global-keymap (make-sparse-keymap) theme-keymap-store)))
     (dolist (binding-definition (quote ,body))
       (let ((binding-type (first binding-definition))
             (binding-key-stroke (second binding-definition))
             (binding-function (third binding-definition)))
         (case binding-type
           (sticky
            (define-key theme-global-keymap (read-kbd-macro binding-key-stroke) binding-function))
           (global
            (define-key theme-global-keymap (read-kbd-macro binding-key-stroke) binding-function)))))))
