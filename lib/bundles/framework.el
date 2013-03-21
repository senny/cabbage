(defvar cabbage--globaly-bound-keys-alist '())
(defvar cabbage--deprecated-bundles '())

(defun cabbage-bundle-active-p (bundle-name)
  (member bundle-name cabbage-bundles))

(defun cabbage-flymake-active-p ()
  cabbage-use-flymake)

(defun cabbage-global-set-key (binding func)
  (add-to-list 'cabbage--globaly-bound-keys-alist (cons binding func))
  (global-set-key binding func))

(defun cabbage-clear-local-bindings ()
  (interactive)
  (dolist (binding cabbage--globaly-bound-keys-alist)
    (local-unset-key (car binding))))

(add-hook 'after-change-major-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'org-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'org-agenda-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'comint-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'inf-ruby-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'erlang-mode-hook 'cabbage-clear-local-bindings)
(add-hook 'diff-mode 'cabbage-clear-local-bindings)
(add-hook 'magit-mode 'cabbage-clear-local-bindings)
(add-hook 'html-mode-hook 'cabbage-clear-local-bindings)

(defun cabbage-lisp-buffer-p ()
  (memql major-mode '(emacs-lisp-mode lisp-mode lisp-interaction-mode)))

(defun cabbage-flymake-init ()
  "registered as hook in bundles ; configures flymake"
  (cabbage-vendor 'flymake-point)

  (local-set-key (kbd "C-§") 'flymake-goto-next-error))

(defun cabbage-insert-pairs-p ()
  cabbage-insert-pairs)

;; API: project
(defvar cabbage-project-root-indicators
  '("Rakefile" ".git" "Gemfile")
  "list of file-/directory-names which indicate a root of a project")

(defun cabbage-project-p ()
  "Returns whether cabbage has access to a project root or not"
  (stringp (cabbage-project-root)))

(defun cabbage-project-parent-directory (a-directory)
  "Returns the directory of which a-directory is a child"
  (file-name-directory (directory-file-name a-directory)))

(defun cabbage-project-root-directory-p (a-directory)
  "Returns t if a-directory is the root"
  (equal a-directory (cabbage-project-parent-directory a-directory)))

(defun cabbage-project-root (&optional directory)
  "Finds the root directory of the project by walking the directory tree until it finds a project root indicator."
  (let* ((directory (file-name-as-directory (or directory (expand-file-name default-directory))))
         (present-files (directory-files directory)))
    (cond ((cabbage-project-root-directory-p directory) nil)
          ((> (length (intersection present-files cabbage-project-root-indicators :test 'string=)) 0) directory)
          (t (cabbage-project-root (file-name-directory (directory-file-name directory)))))))

(defun cabbage-project-expand-path (&rest segments)
  "Construct a path relative to the cabbage-project-root"
  (let ((project-root (cabbage-project-root)))
    (when (not project-root) (error "Could not detect project root"))
    (let ((path (mapconcat 'identity segments "/"))
          (installation-dir (replace-regexp-in-string "/$" "" project-root)))
      (expand-file-name (concat installation-dir "/" path)))))

;; API: integrated testing
(defvar cabbage-testing--last-project-root nil
  "cache for the project-root of the last executed spec-file")

(defvar cabbage-testing--last-spec-file nil
  "cache for the last executed spec-file")

(defvar cabbage-testing--last-execute-function nil
  "cache for the last test executing function")

(defvar cabbage-testing-execute-function nil
  "set this variable to the testing function, which executes tests.
a value of nil means, this buffer does not contain an executable test")
(make-variable-buffer-local 'cabbage-testing-execute-function)

(defun cabbage-testing-execute-test ()
  (interactive)
  (when buffer-file-name (save-buffer))
  (cond (cabbage-testing-execute-function
         (progn
           (setq cabbage-testing--last-project-root (cabbage-project-root))
           (setq cabbage-testing--last-test-file buffer-file-name)
           (setq cabbage-testing--last-execute-function cabbage-testing-execute-function)
           (funcall cabbage-testing-execute-function buffer-file-name)))
        ((and cabbage-testing--last-project-root
              cabbage-testing--last-test-file
              cabbage-testing--last-execute-function)
         (let ((default-directory cabbage-testing--last-project-root))
           (funcall cabbage-testing--last-execute-function cabbage-testing--last-test-file)))
        (t
         (message "Don't know what to do. Open an executable test and run again."))))


(defun cabbage-load-bundle (bundle)
  "Load the given BUNDLE (which can be either a symbol or a string."

  (interactive (list (make-symbol
                      (ido-completing-read
                       "Bundle: "
                       (cabbage-bundles--list-available)))))

  (let ((bundle-name (cabbage--bundle-name bundle)))
    (when (member bundle-name cabbage--deprecated-bundles)
      (warn (concat "the bundle '" bundle-name "' is deprecated. We are planning to remove the bundle in future versions of cabbage")))
    (cabbage--load-bundle-internal bundle)))

(defun cabbage--load-bundle-internal (bundle)
  (add-to-list 'cabbage-bundles bundle)
  (dolist (bundle-path (cabbage--bundle-path bundle))
    (load bundle-path t)))

(defun cabbage--bundle-name (symbol-or-string)
  (if (symbolp symbol-or-string)
      (symbol-name bundle) symbol-or-string))

(defun cabbage--bundle-path (bundle &optional filename)
  (let ((name (or filename "bundle")))
    (mapcar (lambda (bundle-repository)
              (concat bundle-repository
                      (cabbage--bundle-name bundle)
                      "/"
                      name))
            cabbage-bundle-dirs)))

(defun cabbage-list-bundles ()
  "Show available and enabled list of bundles"
  (interactive)

  (let* ((bundles (cabbage-bundles--list-available))
         (active (mapcar (lambda (e) (symbol-name e)) cabbage-bundles))
         (inactive (delq nil (mapcar (lambda (e)
                                       (if (not (member e active))
                                           e))
                                     bundles))))

    (message (concat
              "cabbage-bundles: \n"
              (concat "INACTIVE: " (mapconcat 'identity inactive ", "))
              "\n"
              (concat "ACTIVE: " (mapconcat 'identity active ", "))))))

(defun cabbage-bundles--list-available ()
  (sort (reduce 'union (mapcar (lambda (repository)
                                 (directory-files repository nil "^[^.]"))
                               cabbage-bundle-dirs))
        (lambda (bundle1 bundle2) (string< bundle1 bundle2))))

(defun cabbage-load-bundle-dependencies (bundle dependencies)
  (dolist (dependency dependencies)
    (dolist (dependency-path (cabbage--bundle-path bundle dependency))
      (load dependency-path t))))
