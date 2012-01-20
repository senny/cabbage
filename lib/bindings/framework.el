(defvar e-max--globaly-bound-keys-alist '())

(defvar e-max-bindings-api-is-active nil
  "This variable holds the state if the binding-api is active or not")

(defvar e-max-bindings-original-state (make-hash-table :test 'equal)
  "Hash to store the bindings before the e-max-binding-api was activated")

(defun e-max-bindings-deactivate ()
  (interactive)
  (when (e-max-bindings-is-active-p)
    (maphash (lambda (key value)
               (global-set-key (read-kbd-macro key) value)) e-max-bindings-original-state)
    (setq e-max-bindings-api-is-active nil)
    (setq e-max-bindings-original-state (make-hash-table :test 'equal))))

(defun e-max-bindings-is-active-p ()
  e-max-bindings-api-is-active)

(defun e-max-global-set-key (binding func)
  (add-to-list 'e-max--globaly-bound-keys-alist (cons binding func))
  (global-set-key binding func))

(defmacro* e-max-bindings-make-theme (name &rest body)
  (let ((binding-theme-function-symbol
         (intern (concat "binding-theme-"
                         (replace-regexp-in-string "\s" "-" (downcase name))))))
    `(progn
       (defun ,binding-theme-function-symbol ()
         (interactive)
         (setq e-max-bindings-api-is-active t)
         (dolist (binding-definition (quote ,body))
           (let ((binding-type (first binding-definition))
                 (binding-key-stroke (second binding-definition))
                 (binding-function (third binding-definition)))
             (case binding-type
               (unset
                (global-unset-key (read-kbd-macro binding-key-stroke)))
               (sticky
                (puthash binding-key-stroke (key-binding (read-kbd-macro binding-key-stroke)) e-max-bindings-original-state)
                (e-max-global-set-key (read-kbd-macro binding-key-stroke) binding-function))
               (global
                (puthash binding-key-stroke (key-binding (read-kbd-macro binding-key-stroke)) e-max-bindings-original-state)
                (global-set-key (read-kbd-macro binding-key-stroke) binding-function)))))))))
