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


;;;; -------------------------------------
;;;; Bundle

;; helpers


(defun e-max-plone-make-changelog-entry ()
  (interactive)

  (let ((name (or e-max-plone-changelog-name
                  (user-login-name))))

    (beginning-of-buffer)
    (forward-paragraph 2)

    (newline)
    (insert "* ")
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


;; hooks

(defun e-max-plone-python-keybindings ()
  (define-key python-mode-map (kbd "C-c f c") 'e-max-plone-find-changelog-make-entry))

(add-hook 'python-mode-hook 'e-max-plone-python-keybindings)

(when e-max-plone-enable-po-mode
  (e-max-vendor 'po-mode)

  (add-to-list 'auto-mode-alist '("\\.po\\(t\\)?$" . po-mode)))

(add-to-list 'auto-mode-alist '("\\.\\(z\\)?pt$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.zcml$" . nxml-mode))
