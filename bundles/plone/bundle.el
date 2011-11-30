;; Configuration

(defcustom e-max-plone-enable-po-mode
  t
  "Use po-mode for translation files"
  :type 'boolean
  :group 'e-max)

(defcustom e-max-plone-changelog-name
  nil
  "Name to use in changelogs."
  :type 'string
  :group 'e-max)

(defcustom e-max-plone-known-buildout-instances
  '(("bin/instance" "fg")
    ("bin/instance1" "fg")
    ("bin/instanceadm" "fg")
    ("bin/serve" ""))
  "List of known instance names. The instances are usually zope instance scripts,
but may be any type of python script, startable in pdb-mode. They are used when
starting the instance within emacs, the first found instance name will be used.
The key is the path to the script relative to the buildout root, the value are
optional parameters."
  :type 'plist
  :group 'e-max)

(defcustom e-max-plone-known-buildout-test-scripts
  '(("bin/test" "")
    ("bin/nose" "")
    ("bin/freshen" ""))
  "List of known instance names. The instances are usually zope instance scripts,
but may be any type of python script, startable in pdb-mode. They are used when
starting the instance within emacs, the first found instance name will be used.
The key is the path to the script relative to the buildout root, the value are
optional parameters."
  :type 'plist
  :group 'e-max)

(defcustom e-max-plone-run-in-perspective t
  "Runs tests and server in another perspective.")


;;;; -------------------------------------
;;;; Bundle

;; dependencies
(e-max-vendor 'textmate)
(load (concat e-max-bundle-dir "plone/lookup"))
(load (concat e-max-bundle-dir "plone/buildout"))

;; add additional files / directories to execlude from textmate-goto-file
(when (not (string-match "eggs" *textmate-gf-exclude*))
  (setq *textmate-gf-exclude*
        (replace-regexp-in-string ".pyc"
                                  ".pyc|eggs|parts|coverage"
                                  *textmate-gf-exclude*))

  (setq *textmate-project-roots*
        (append *textmate-project-roots* '("setup.py" "bootstrap.py"))))


;; helpers

(defun e-max-plone--find-buildout-root (path &optional first-match)
  "Search PATH for a buildout root.

If a buildout root is found return the path, othwise return
nil."
  ;; find the most top one, not the first one
  (let* ((dir default-directory)
         (previous dir))
    (while (not (equalp dir nil))
      (setq dir (e-max--find-parent-with-file dir "bootstrap.py"))
      (when (and first-match dir)
        (setq previous dir)
        (setq dir nil))

      (if (not (equalp dir nil))
          (progn
            (setq previous dir)
            ;; get parent dir
            (setq dir (file-name-directory (directory-file-name dir))))))
    previous))


(defun e-max-plone-make-changelog-entry ()
  (interactive)

  (let ((name (or e-max-plone-changelog-name
                  (user-login-name))))

    (beginning-of-buffer)
    (forward-paragraph 2)

    (newline)
    (insert "- ")
    (newline)
    (insert (concat "  [" name "]"))
    (newline)
    (previous-line 2)
    (end-of-line)))

(defun e-max-plone-find-changelog-make-entry ()
  (interactive)
  (let* ((egg-root (e-max--find-parent-with-file default-directory "setup.py"))
         (history-file (concat egg-root "docs/HISTORY.txt"))
         (changelog-file (concat egg-root "CHANGELOG.txt")))

    (if (file-exists-p history-file)
        (progn
          (find-file history-file)
          (e-max-plone-make-changelog-entry))
      (if (file-exists-p changelog-file)
          (progn
            (find-file changelog-file)
            (e-max-plone-make-changelog-entry))))))


(defun e-max-plone-find-file-in-package (&optional buildout-root)
  "Prompts for another package to open, which is in the same src directory,
then prompts for a file. Expects to be within a package
 (e.g. .../src/some.package/some/package/anyfile.py)."
  (interactive)

  (let* ((root (replace-regexp-in-string
                "\/?$" "/"
                (or buildout-root
                    (e-max--find-parent-with-file default-directory "src"))))
         (srcpath (concat root "src/"))
         (path nil))

    (if (file-accessible-directory-p srcpath)
        (setq path (concat srcpath
                           (ido-completing-read
                            "Package: "
                            (directory-files srcpath nil "^[^.]"))))

      (setq path root))

    (setq path (replace-regexp-in-string "\/*$" "" path))
    (find-file
     (concat path "/"
             (textmate-completing-read
              "Find file: "
              (mapcar
               (lambda (e)
                 (replace-regexp-in-string
                  "^\/?" ""
                  (replace-regexp-in-string (concat path "/") "" (concat "/" e))))
               (textmate-project-files path)))))))


(defun e-max-plone-ido-find-buildout (&optional projects-root)
  "Open a file within a buildout checkout."
  (interactive)

  (let* ((projectsdir (replace-regexp-in-string
                       "\/?$" "/"
                       (or projects-root e-max-project-location)))
         (project-name (ido-completing-read
                        "Project: "
                        (directory-files projectsdir nil "^[^.]")))
         (project-path (concat projectsdir project-name))

         (buildout-name (ido-completing-read
                         (concat project-name " buildout: ")
                         (directory-files project-path nil "^[^.]")))
         (buildout-path (concat project-path "/" buildout-name "/")))

    (e-max-persp (concat project-name "/" buildout-name))
    (e-max-plone-find-file-in-package buildout-path)))


(defun e-max-plone-reload-code (opts)
  (interactive "MOptions [-c, -z, -u, -p, -H, -P]:")
  (shell-command (concat e-max-repository "bin/zope_reload_code.py" opts)))

;; hooks & customization

(when e-max-plone-enable-po-mode
  (e-max-vendor 'po-mode)

  (add-to-list 'auto-mode-alist '("\\.po\\(t\\)?$" . po-mode)))

(add-to-list 'auto-mode-alist '("\\.\\(z\\)?pt$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.zcml$" . nxml-mode))


(defun e-max-plone--python-bindings ()
  (define-key python-mode-map (kbd "C-M-<return>") 'e-max-plone-goto-defition)
  (define-key python-mode-map (kbd "C-M-S-<return>") 'e-max-plone-lookup-import))

(add-hook 'python-mode-hook 'e-max-plone--python-bindings)


(defun e-max-plone--init-snippets ()
  (when (e-max-bundle-active-p 'snippets)
    (add-to-list 'yas/root-directory
                 (concat (concat e-max-bundle-dir "plone/snippets")) t)
    (yas/reload-all)))

(add-hook 'python-mode-hook 'e-max-plone--init-snippets)

;; global bindings

(e-max-global-set-key (kbd "C-c f c") 'e-max-plone-find-changelog-make-entry)
(e-max-global-set-key (kbd "M-T") 'e-max-plone-find-file-in-package)
(e-max-global-set-key (kbd "C-p b") 'e-max-plone-ido-find-buildout)
(e-max-global-set-key (kbd "C-c f r") 'e-max-plone-reload-code)
(e-max-global-set-key (kbd "C-c f f") 'e-max-plone-run)
(e-max-global-set-key (kbd "C-c f t") 'e-max-plone-tests)
