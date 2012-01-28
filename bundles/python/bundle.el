;; Configuration

(defcustom e-max-python-pyflakes-enabled
  t
  "Enable flymake with pyflakes in python mode"
  :type 'boolean
  :group 'e-max)


;;;; -------------------------------------
;;;; Bundle


;; helpers

(defun e-max-python--sort-lines-at-point ()
  "Sorts lines of the block at point. Used for sorting python imports."
  (interactive)
  (mark-paragraph)
  (call-interactively 'sort-lines))


;; hooks

(defun e-max-python-set-pairs ()
  (e-max--set-pairs '("(" "{" "[" "\"" "\'" "`")))

(add-hook 'python-mode-hook 'e-max-python-set-pairs)


(defun e-max-python--default-config ()
  (set (make-local-variable 'tab-width) 4))

(add-hook 'python-mode-hook 'e-max-python--default-config)

(defun e-max-python-keybindings ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-c f s") 'e-max-python--sort-lines-at-point))

(add-hook 'python-mode-hook 'e-max-python-keybindings)

(defun e-max-python-pep8-finished (buffer msg)
  (when (or (eq last-command 'e-max-python-pep8)
            (eq last-command 'e-max-python-pylint))
        (pop-to-buffer buffer)
        (next-error-follow-minor-mode t)
        (goto-line 5)
        (next-error-follow-mode-post-command-hook)))

(defun e-max-python-pep8 ()
  "Check for pep8 errors and go to the first error."
  (interactive)

  (e-max-vendor 'python-pep8)
  (require 'tramp)

  (add-to-list 'compilation-finish-functions 'e-max-python-pep8-finished)
  (pep8))

(defun e-max-python-configure-pep8 ()
  (local-set-key (kbd "C-°") 'e-max-python-pep8))

(add-hook 'python-mode-hook 'e-max-python-configure-pep8)


(defun e-max-python-pylint ()
  "Check for pylint errors on key-press rather than using flymake."
  (interactive)
  (let ((command (concat (executable-find "epylint")
                         " " buffer-file-name
                         ;; this regexp reformats the epylint output so that it matches the pep8 output
                         ;; XXX we could "let" python-pep8-regexp-alist instead.
                         " | sed -e 's/\\([^:]*:[^:]*:\\)\\([^(]*(\\)\\([EW][0-9]*\\)\\(.*\\)/\\11: \\3\\2\\3\\4/'")))
    (add-to-list 'compilation-finish-functions 'e-max-python-pep8-finished)
    (compilation-start command 'python-pep8-mode)))

(defun e-max-python-configure-pylint ()
  (local-set-key (kbd "C-M-§") 'e-max-python-pylint))

(add-hook 'python-mode-hook 'e-max-python-configure-pylint)

(defun e-max-python-flymake ()
  (when (and e-max-python-pyflakes-enabled (executable-find "pyflakes"))
    (when (load "flymake" t)
      (e-max-flymake-init)

      (defun flymake-pyflakes-init ()
        (let* ((temp-file (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
               (local-file (file-relative-name
                            temp-file
                            (file-name-directory buffer-file-name))))
          (list (executable-find "pyflakes") (list local-file))))

      (add-to-list 'flymake-allowed-file-name-masks
                   '("\\.py\\'" flymake-pyflakes-init)))

    (flymake-find-file-hook)))

(add-hook 'python-mode-hook 'e-max-python-flymake)


(defun e-max-python-init-snippets ()
  (when (e-max-bundle-active-p 'snippets)
    (add-to-list 'yas/root-directory
                 (concat (concat e-max-bundle-dir "python/snippets")) t)
    (yas/reload-all)))

(add-hook 'python-mode-hook 'e-max-python-init-snippets)
