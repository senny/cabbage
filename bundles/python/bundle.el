;; Configuration

(defcustom cabbage-python-pyflakes-enabled
  t
  "Enable flycheck with pyflakes in python mode"
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

;; flycheck

(when (cabbage-flycheck-active-p)
  (cabbage-flycheck-init)

  (when cabbage-python-pyflakes-enabled
    (flycheck-define-checker python-pyflakes
      "A Python syntax and style checker using the pyflakes utility.
See URL `http://pypi.python.org/pypi/pyflakes'."
      :command ("pyflakes" source-inplace)
      :error-patterns
      ((error line-start (file-name) ":" line ":" (message) line-end))
      :modes python-mode)

    (add-to-list 'flycheck-checkers 'python-pyflakes))

  (add-hook 'python-mode-hook 'cabbage-flycheck-keybindings)
  (add-hook 'python-mode-hook 'flycheck-mode))

;; hooks

(defun cabbage-python-set-pairs ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "`")))

(defun cabbage-python--default-config ()
  (set (make-local-variable 'tab-width) 4))

(defun cabbage-python-keybindings ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-c f s") 'cabbage-python--sort-lines-at-point))

(add-hook 'python-mode-hook 'cabbage-python-set-pairs)
(add-hook 'python-mode-hook 'cabbage-python--default-config)
(add-hook 'python-mode-hook 'cabbage-python-keybindings)
