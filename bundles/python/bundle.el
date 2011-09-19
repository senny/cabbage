;; Configuration

(defcustom e-max-python-pyflakes-enabled
  t
  "Enable flymake with pyflakes in python mode"
  :type 'boolean
  :group 'e-max)


;;;; -------------------------------------
;;;; Bundle

(defun e-max-python-set-pairs ()
  (e-max--set-pairs '("(" "{" "[" "\"" "\'" "`")))

(add-hook 'python-mode-hook 'e-max-python-set-pairs)


(defun e-max-python-keybindings ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-§") 'flymake-goto-next-error))

(add-hook 'python-mode-hook 'e-max-python-keybindings)

(defun e-max-python-pep8-finished (buffer msg)
  (pop-to-buffer buffer)
  (next-error-follow-minor-mode t)
  (goto-line 5)
  (next-error-follow-mode-post-command-hook))

(defun e-max-python-pep8 ()
  "Check for pep8 errors and go to the first error."
  (interactive)

  (add-to-list 'compilation-finish-functions 'e-max-python-pep8-finished)
  (pep8))

(defun e-max-python-configure-pep8 ()
  (e-max-vendor 'python-pep8)
  (local-set-key (kbd "C-°") 'e-max-python-pep8))

(add-hook 'python-mode-hook 'e-max-python-configure-pep8)


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

    (add-hook 'find-file-hook 'flymake-find-file-hook)))

(add-hook 'python-mode-hook 'e-max-python-flymake)
