;; Configuration

(defcustom cabbage-plone-enable-po-mode
  t
  "Use po-mode for translation files"
  :type 'boolean
  :group 'cabbage)

(defcustom cabbage-plone-changelog-name
  nil
  "Name to use in changelogs."
  :type 'string
  :group 'cabbage)

(defcustom cabbage-plone-known-buildout-instances
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
  :group 'cabbage)

(defcustom cabbage-plone-known-buildout-test-scripts
  '(("bin/test" "")
    ("bin/nose" "")
    ("bin/freshen" ""))
  "List of known instance names. The instances are usually zope instance scripts,
but may be any type of python script, startable in pdb-mode. They are used when
starting the instance within emacs, the first found instance name will be used.
The key is the path to the script relative to the buildout root, the value are
optional parameters."
  :type 'plist
  :group 'cabbage)

(defcustom cabbage-plone-run-in-perspective t
  "Runs tests and server in another perspective.")


;;;; -------------------------------------
;;;; Bundle

;; dependencies
(cabbage-vendor 'textmate)
(cabbage-load-bundle-dependencies "plone" '("lookup" "buildout" "z3cinspect"))

;; add additional files / directories to execlude from textmate-goto-file
(when (not (string-match "eggs" *textmate-gf-exclude*))
  (setq *textmate-gf-exclude*
        (replace-regexp-in-string ".pyc"
                                  ".pyc|eggs|parts|coverage"
                                  *textmate-gf-exclude*))

  (setq *textmate-project-roots*
        (append *textmate-project-roots* '("setup.py" "bootstrap.py"))))


;; helpers

(defun cabbage-plone--find-file-in-package (path)
  "Open a file using textmate-completing-read within a python package.
This excludes paths as bin/, src/ etc."
  (let ((path (replace-regexp-in-string "\/*$" "" path)))
    (find-file
     (concat
      path "/"
      (textmate-completing-read
       "Find file: "
       (mapcar
        (lambda (e)
          (replace-regexp-in-string
           "^\/?" ""
           (replace-regexp-in-string (concat path "/") "" (concat "/" e))))

        (let* ((pathend (mapconcat 'identity (last (split-string path "/") 2) "/"))
               (*textmate-gf-exclude*
                (replace-regexp-in-string
                 "build"
                 (concat "build|"
                         (concat pathend "/src|")
                         (concat pathend "/parts"))
                 *textmate-gf-exclude*)))
          (textmate-project-files path))))))))

(defun cabbage-plone--find-buildout-root (path &optional first-match)
  "Search PATH for a buildout root.

If a buildout root is found return the path, othwise return
nil."
  ;; find the most top one, not the first one
  (when (cabbage--find-parent-with-file path "bootstrap.py")
    (let* ((dir default-directory)
           (previous dir))
      (while (not (equalp dir nil))
        (setq dir (cabbage--find-parent-with-file dir "bootstrap.py"))
        (when (and first-match dir)
          (setq previous dir)
          (setq dir nil))

        (if (not (equalp dir nil))
            (progn
              (setq previous dir)
              ;; get parent dir
              (setq dir (file-name-directory (directory-file-name dir))))))
      previous)))


(defun cabbage-plone-make-changelog-entry ()
  (interactive)

  (let ((name (or cabbage-plone-changelog-name
                  (user-login-name))))

    (beginning-of-buffer)
    (forward-paragraph 2)

    ;; Remove "- Nothing changed yet", if it is there.
    (mark-paragraph)
    (replace-string "\n- Nothing changed yet.\n" "")

    (newline)
    (insert "- ")
    (newline)
    (insert (concat "  [" name "]"))
    (newline)
    (previous-line 2)
    (end-of-line)))

(defun cabbage-plone-find-changelog-make-entry ()
  (interactive)
  (let* ((egg-root (cabbage--find-parent-with-file default-directory "setup.py"))
         (history-file (concat egg-root "docs/HISTORY.txt"))
         (changelog-file (concat egg-root "CHANGELOG.txt")))

    (if (file-exists-p history-file)
        (progn
          (find-file history-file)
          (cabbage-plone-make-changelog-entry))
      (if (file-exists-p changelog-file)
          (progn
            (find-file changelog-file)
            (cabbage-plone-make-changelog-entry))))))


(defun cabbage-plone-find-file-in-package (&optional buildout-root)
  "Prompts for another package to open, which is in the same src directory,
then prompts for a file. Expects to be within a package
 (e.g. .../src/some.package/some/package/anyfile.py)."
  (interactive)

  (let* ((root (replace-regexp-in-string
                "\/?$" "/"
                (or buildout-root
                    (cabbage-plone--find-buildout-root default-directory))))
         (srcpath (concat root "src/"))
         (path nil))

    (if (file-accessible-directory-p srcpath)
        (setq path (expand-file-name
                    (concat srcpath
                            (ido-completing-read
                             "Package: "
                             (append (list "..")
                                     (directory-files srcpath nil "^[^.]"))))))

      (setq path root))

    (setq path (replace-regexp-in-string "\/*$" "" path))
    (cabbage-plone--find-file-in-package path)))



(defun cabbage-plone-ido-find-buildout (&optional projects-root)
  "Open a file within a buildout checkout."
  (interactive)

  (let* ((projectsdir (replace-regexp-in-string
                       "\/?$" "/"
                       (or projects-root cabbage-project-location)))
         (project-name (ido-completing-read
                        "Project: "
                        (directory-files projectsdir nil "^[^.]")))
         (project-path (concat projectsdir project-name))

         (buildout-name (ido-completing-read
                         (concat project-name " buildout: ")
                         (directory-files project-path nil "^[^.]")))
         (buildout-path (concat project-path "/" buildout-name "/")))

    (cabbage-persp (concat project-name "/" buildout-name))
    (cabbage-plone-find-file-in-package buildout-path)))


(defun cabbage-plone-reload-code (opts)
  (interactive "MOptions [-c, -z, -u, -p, -H, -P]:")
  (shell-command (concat cabbage-repository "bin/zope_reload_code.py" opts)))

;; hooks & customization

(when cabbage-plone-enable-po-mode
  (cabbage-vendor 'po-mode)

  (add-to-list 'auto-mode-alist '("\\.po\\(t\\)?$" . po-mode)))

(add-to-list 'auto-mode-alist '("\\.[zc]?pt$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.zcml$" . nxml-mode))


(defun cabbage-plone--xml-flymake ()
  (when (and (cabbage-bundle-active-p 'xml)
             cabbage-xml-flymake-enabled
             (executable-find "xml"))

    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.[zc]?pt$" flymake-xml-init))
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.zcml$" flymake-xml-init))))

(add-hook 'nxml-mode-hook 'cabbage-plone--xml-flymake)


(defun cabbage-plone--python-bindings ()
  (define-key python-mode-map (kbd "C-M-<return>") 'cabbage-plone-goto-defition)
  (define-key python-mode-map (kbd "C-M-S-<return>") 'cabbage-plone-lookup-import))

(add-hook 'python-mode-hook 'cabbage-plone--python-bindings)

(defadvice textmate-goto-file (around textmate-goto-file-in-buildout activate)
  "Change `textmate-goto-file' to ignore files as src/* bin/* of a package
when within a buildout environment."
  ;; Only use reduced find-file implementation when we are in a buildout
  ;; environment.
  (if (cabbage-plone--find-buildout-root default-directory)
      (cabbage-plone--find-file-in-package (textmate-project-root))
    ad-do-it))
