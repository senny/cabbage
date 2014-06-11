;; Configuration

(defcustom cabbage-python-pyflakes-enabled
  t
  "Enable flymake with pyflakes in python mode"
  :type 'boolean
  :group 'cabbage)


;;;; -------------------------------------
;;;; Bundle


;; helpers

(defun cabbage-python--sort-lines-at-point ()
  "Sorts lines of the block at point. Used for sorting python imports."
  (interactive)
  (mark-paragraph)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))


;; hooks

(defun cabbage-python-set-pairs ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "`")))

(add-hook 'python-mode-hook 'cabbage-python-set-pairs)


(defun cabbage-python--default-config ()
  (set (make-local-variable 'tab-width) 4))

(add-hook 'python-mode-hook 'cabbage-python--default-config)


(defun cabbage-python-keybindings ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-c f s") 'cabbage-python--sort-lines-at-point))

(add-hook 'python-mode-hook 'cabbage-python-keybindings)

(defun cabbage-python-pep8-finished (buffer msg)
  (when (or (eq last-command 'cabbage-python-pep8)
            (eq last-command 'cabbage-python-pylint)
            (eq last-command 'cabbage-plone--pep8-package))
    (pop-to-buffer buffer)
    (next-error-follow-minor-mode t)
    (goto-line 5)
    (next-error-follow-mode-post-command-hook)
    (compile-goto-error)))

(defun cabbage-python-pep8 ()
  "Check for pep8 errors and go to the first error."
  (interactive)

  (cabbage-vendor 'python-pep8)
  (require 'tramp)

  (add-to-list 'compilation-finish-functions 'cabbage-python-pep8-finished)
  (pep8))

(defun cabbage-python-configure-pep8 ()
  (local-set-key (kbd "C-°") 'cabbage-python-pep8))

(add-hook 'python-mode-hook 'cabbage-python-configure-pep8)


(defun cabbage-python-pylint ()
  "Check for pylint errors on key-press rather than using flymake."
  (interactive)
  (let ((command (concat (executable-find "epylint")
                         " " buffer-file-name
                         ;; this regexp reformats the epylint output so that it matches the pep8 output
                         ;; XXX we could "let" python-pep8-regexp-alist instead.
                         " | sed -e 's/\\([^:]*:[^:]*:\\)\\([^(]*(\\)\\([EW][0-9]*\\)\\(.*\\)/\\11: \\3\\2\\3\\4/'")))
    (add-to-list 'compilation-finish-functions 'cabbage-python-pep8-finished)
    (compilation-start command 'python-pep8-mode)))

(defun cabbage-python-configure-pylint ()
  (local-set-key (kbd "C-M-§") 'cabbage-python-pylint))

(add-hook 'python-mode-hook 'cabbage-python-configure-pylint)

(defun cabbage-python-flymake ()
  (when (and cabbage-python-pyflakes-enabled (executable-find "pyflakes"))
    (when (load "flymake" t)
      (cabbage-flymake-init)

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

(add-hook 'python-mode-hook 'cabbage-python-flymake)
