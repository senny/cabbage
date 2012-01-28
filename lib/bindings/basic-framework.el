(defvar e-max-bindings--globaly-bound-keys-alist '())

(defvar e-max-bindings-themes-store (make-hash-table :test 'equal))

(defun e-max-global-set-key (binding func)
  (add-to-list 'e-max-bindings--globaly-bound-keys-alist (cons binding func))
  (global-set-key binding func))

(defun e-max-clear-local-bindings ()
  (interactive)
  (dolist (binding e-max-bindings--globaly-bound-keys-alist)
    (local-unset-key (car binding))))

(add-hook 'after-change-major-mode-hook 'e-max-clear-local-bindings)
(add-hook 'org-mode-hook 'e-max-clear-local-bindings)
(add-hook 'org-agenda-mode-hook 'e-max-clear-local-bindings)
(add-hook 'comint-mode-hook 'e-max-clear-local-bindings)
(add-hook 'inf-ruby-mode-hook 'e-max-clear-local-bindings)
(add-hook 'erlang-mode-hook 'e-max-clear-local-bindings)
(add-hook 'diff-mode 'e-max-clear-local-bindings)
(add-hook 'magit-mode 'e-max-clear-local-bindings)
(add-hook 'html-mode-hook 'e-max-clear-local-bindings)

(defun e-max-bindings-activate (theme)
  (interactive
   (list (ido-completing-read "Bindings: " e-max-bindings-registerd-themes)))
  (when (not (e-max-bindings-is-theme-p theme))
    (error (concat "'" theme "'" "is not a valid binding-theme")))
  (dolist (binding-definition (gethash theme e-max-bindings-themes-store))
    (let ((binding-type (first binding-definition))
          (binding-key-stroke (second binding-definition))
          (binding-function (third binding-definition)))
      (case binding-type
        (unset
         (global-unset-key (read-kbd-macro binding-key-stroke)))
        (sticky
         (e-max-global-set-key (read-kbd-macro binding-key-stroke) binding-function))
        (global
         (global-set-key (read-kbd-macro binding-key-stroke) binding-function))
        (t
         (define-key (eval binding-type) (read-kbd-macro binding-key-stroke) binding-function)
         )))))

(defmacro* e-max-bindings-make-theme (name &rest body)
  (add-to-list 'e-max-bindings-registerd-themes name)
  `(puthash ,name (quote ,body) e-max-bindings-themes-store))
