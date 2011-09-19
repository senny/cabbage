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

(defvar e-max--globaly-bound-keys-alist '())

(defun e-max-bundle-active-p (bundle-name)
  (member bundle-name e-max-bundles))

(defun e-max-flymake-active-p ()
  e-max-use-flymake)

(defun e-max-global-set-key (binding func)
  (add-to-list 'e-max--globaly-bound-keys-alist (cons binding func))
  (global-set-key binding func))

(defun e-max-clear-local-bindings ()
  (interactive)
  (dolist (binding e-max--globaly-bound-keys-alist)
    (local-unset-key (car binding))))

(add-hook 'after-change-major-mode-hook 'e-max-clear-local-bindings)
(add-hook 'org-mode-hook 'e-max-clear-local-bindings)
(add-hook 'org-agenda-mode-hook 'e-max-clear-local-bindings)
(add-hook 'comint-mode-hook 'e-max-clear-local-bindings)
(add-hook 'inf-ruby-mode-hook 'e-max-clear-local-bindings)
(add-hook 'erlang-mode-hook 'e-max-clear-local-bindings)
(add-hook 'diff-mode 'e-max-clear-local-bindings)
(add-hook 'magit-mode 'e-max-clear-local-bindings)

(defun e-max-flymake-init ()
  "registered as hook in bundles ; configures flymake"
  (e-max-vendor 'flymake-point)

  (local-set-key (kbd "C-§") 'flymake-goto-next-error))

(defun e-max-insert-pairs-p ()
  e-max-insert-pairs)
