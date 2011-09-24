;; Configuration

(defcustom e-max-terminal-fix-keys t
  "Replace default multi-term binding fixes with
e-max bindings.")



;;;; -------------------------------------
;;;; Bundle

;; dependencies
(require 'term)
(require 'cl)
(require 'advice)
(e-max-vendor 'multi-term)

;; customizations

(if (not multi-term-program)
    (setq multi-term-program "/bin/zsh"))

(when e-max-terminal-fix-keys
  (setq term-bind-key-alist
        '(("C-c C-c" . term-interrupt-subjob)
          ("C-f" . isearch-forward)
          ("M-j" . e-max-term-backward-char)  ;; backward-char
          ("M-l" . e-max-term-forward-char)  ;; forward -char

          ("M-i" . previous-line)  ;; move up - but don't tell terminal
          ("M-k" . next-line) ;; move down - dont't tell terminal
          ("M-C-i" . term-send-up) ;; tell terminal to move up (history)
          ("M-C-k" . term-send-down) ;; tell terminal to move down (history)

          ("M-u" . e-max-term-backward-word) ;; backward-word
          ("M-o" . e-max-term-forward-word) ;; forward-word
          ("M-<backspace>" . term-send-backward-kill-word)
          ("M-f" . term-send-del)
          ("M-v" . term-paste)
          ))

  (setq term-unbind-key-list (append term-unbind-key-list
                                     '("C-p"))))

;; funs

(defun e-max-terminal-open-term-persp ()
  (interactive)

  (e-max-persp "@terminal"
               (e-max-terminal)))

(e-max-global-set-key (kbd "C-p t") 'e-max-terminal-open-term-persp)

(defun e-max-terminal ()
  (interactive)

  (multi-term-next))

;; XXX: should be improved, especially for multi-line prompts.
(defun e-max-terminal--cursor-in-prompt ()
  "Returns t if the cursor is somewhere at the last line of the current buffer."
  (eq (buffer-end 1) (line-end-position 2)))


;; fixed binding funs

(defun e-max-term-backward-char ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (term-send-left)
    (backward-char)))

(defun e-max-term-forward-char ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (term-send-right)
    (forward-char)))

(defun e-max-term-backward-word ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (term-send-backward-word)
    (backward-word)))

(defun e-max-term-forward-word ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (term-send-forward-word)
    (forward-word)))
