(defvar e-max--globaly-bound-keys-alist '())

(defvar e-max-bindings-themes-store (make-hash-table :test 'equal)
  "this variable holds the configuration data for every registered binding theme.")

(defvar e-max-bindings-tracked-modes '()
  "")

(defvar e-max-emulation-keymap-alist nil
  "")

(defun e-max-bindings-track-mode (mode)
  (when (not (member mode e-max-bindings-tracked-modes))
    (add-to-list 'e-max-bindings-tracked-modes mode)
    (lexical-let* ((mode-name (symbol-name mode))
                   (variable-name (intern (concat "e-max-bindings-is-" mode-name)))
                   (hook-name (intern (concat mode-name "-hook"))))
      (set variable-name nil)
      (make-variable-buffer-local variable-name)
      (add-hook hook-name (lambda ()
                            (set variable-name t)
                            )))))

(defun e-max-bindings-deactivate ()
  (interactive)
  (when (e-max-bindings-is-active-p)
    (dolist (e emulation-mode-map-alists)
      (when (string-match-p "e-max-bindings-" (symbol-name e))
        (setq emulation-mode-map-alists (delq e emulation-mode-map-alists))))
    (setq e-max-bindings-api-is-active nil)))

(defun e-max-bindings-activate (theme)
  (interactive
   (list (ido-completing-read "Bindings: " e-max-bindings-registerd-themes)))
  (when (not (e-max-bindings-is-theme-p theme))
    (error (concat "'" theme "'" "is not a valid binding-theme")))
  (when (e-max-bindings-is-active-p)
    (e-max-bindings-deactivate))
  (setq e-max-emulation-keymap-alist '())
  (maphash (lambda (key value)
             (if (equal key 'sticky)
                 (add-to-list 'e-max-emulation-keymap-alist `(t . ,value))
               (add-to-list 'e-max-emulation-keymap-alist (list (intern (concat "e-max-bindings-is-" (symbol-name key))) value))))
           (gethash theme e-max-bindings-themes-store))
  (add-to-ordered-list 'emulation-mode-map-alists 'e-max-emulation-keymap-alist 1)
  (setq e-max-bindings-api-is-active t))

(defun e-max-bindings-is-theme-p (theme)
  (member theme e-max-bindings-registerd-themes))

(defun e-max-bindings-is-active-p ()
  e-max-bindings-api-is-active)

(defmacro* e-max-bindings-make-theme (name &rest body)
  (add-to-list 'e-max-bindings-registerd-themes name)
  `(let* ((theme-keymap-store (puthash ,name (make-hash-table :test 'equal) e-max-bindings-themes-store ))
          (theme-global-keymap (puthash 'sticky (make-sparse-keymap) theme-keymap-store)))
     (dolist (binding-definition (quote ,body))
       (let ((binding-type (first binding-definition))
             (binding-key-stroke (second binding-definition))
             (binding-function (third binding-definition)))
         (case binding-type
           (sticky
            (define-key theme-global-keymap (read-kbd-macro binding-key-stroke) binding-function))
           (global
            ;; TODO: we need another way to define global bindings beside "sticky-keys"
            (define-key theme-global-keymap (read-kbd-macro binding-key-stroke) binding-function))
           (t
            (let ((mode-specific-keymap (gethash binding-type theme-keymap-store)))
              (when (not mode-specific-keymap)
                (e-max-bindings-track-mode binding-type)
                (setq mode-specific-keymap (puthash binding-type (make-sparse-keymap) theme-keymap-store)))
              (define-key mode-specific-keymap (read-kbd-macro binding-key-stroke) binding-function))
            ))))))
