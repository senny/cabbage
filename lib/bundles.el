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

;; API: project
(defvar e-max-project-root-indicators
  '("Rakefile" ".git" "Gemfile")
  "list of file-/directory-names which indicate a root of a project")

(defun e-max-project-parent-directory (a-directory)
  "Returns the directory of which a-directory is a child"
  (file-name-directory (directory-file-name a-directory)))

(defun e-max-project-root-directory-p (a-directory)
  "Returns t if a-directory is the root"
  (equal a-directory (e-max-project-parent-directory a-directory)))

(defun e-max-project-root (&optional directory)
  "Finds the root directory of the project by walking the directory tree until it finds a project root indicator."
  (let* ((directory (file-name-as-directory (or directory default-directory)))
         (present-files (directory-files directory)))
    (cond ((e-max-project-root-directory-p directory) nil)
          ((> (length (intersection present-files e-max-project-root-indicators :test 'string=)) 0) directory)
          (t (e-max-project-root (file-name-directory (directory-file-name directory)))))))
