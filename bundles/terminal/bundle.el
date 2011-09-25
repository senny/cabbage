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
        '(
          ;; provide some needed functions on other bindings, since they
          ;; conflict with emacs bindings
          ("C-c C-c" . term-interrupt-subjob)
          ("C-c C-d" . term-send-raw)
          ("C-c <escape>" . e-max-term-escape)
          ("C-<escape>" . e-max-term-escape)

          ;; movement
          ("M-i" . e-max-term-up)  ;; move up - but dont tell terminal
          ("M-k" . e-max-term-down) ;; move down - dont tell terminal
          ("M-C-i" . term-send-up) ;; tell terminal to move up (history)
          ("M-C-k" . term-send-down) ;; tell terminal to move down (history)

          ("M-j" . e-max-term-backward-char)
          ("M-l" . e-max-term-forward-char)
          ("M-L" . e-max-term-end-of-line)
          ("M-C-l" . e-max-term-end-of-line)
          ("M-J" . e-max-term-beginning-of-line)
          ("M-C-j" . e-max-term-beginning-of-line)
          ("M-u" . e-max-term-backward-word) ;; backward-word
          ("M-o" . e-max-term-forward-word) ;; forward-word

          ;; searching
          ("C-f" . isearch-forward)

          ;; modifying
          ("M-d" . term-send-backspace)
          ("M-f" . term-send-del)
          ("<delete>" . term-send-del)
          ("M-<backspace>" . term-send-backward-kill-word)
          ("M-v" . term-paste)
          ))

  (setq term-unbind-key-list (append term-unbind-key-list
                                     '("C-p"
                                       "C-a"
                                       "C-w"
                                       "C-s"
                                       "C-d"
                                       ))))

;; funs

(defun e-max-terminal-open-term-persp ()
  (interactive)

  (e-max-persp "@terminal"
               (multi-term-next)))

(e-max-global-set-key (kbd "C-p t") 'e-max-terminal-open-term-persp)
(e-max-global-set-key (kbd "C-x t") 'multi-term)

(defun e-max-terminal--input-possible-at-row ()
  "Returns t if the emacs-cursor is at a point where the shell allows
input. This is usually the case when the emacs-cursor is at the same
row as the terminal-cursor."
  (eq term-current-row (- (line-number-at-pos) 1)))

;; XXX: should be improved, especially for multi-line prompts.
(defun e-max-terminal--cursor-in-prompt ()
  "Returns t if the cursor is in the prompt area. This is usually the
case when it is at the last line."
  (eq (buffer-end 1) (line-end-position 2)))


;; fixed binding funs

(defun e-max-term-up ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (previous-line)
    (term-send-up)))

(defun e-max-term-down ()
  (interactive)
  (if (e-max-terminal--cursor-in-prompt)
      (next-line)
    (term-send-down)))

(defun e-max-term-backward-char ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-left)
    (backward-char)))

(defun e-max-term-forward-char ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-right)
    (forward-char)))

(defun e-max-term-backward-word ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-backward-word)
    (backward-word)))

(defun e-max-term-forward-word ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-forward-word)
    (forward-word)))

(defun e-max-term-end-of-line ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-raw-string "\C-E")
    (end-of-line)))

(defun e-max-term-beginning-of-line ()
  (interactive)
  (if (e-max-terminal--input-possible-at-row)
      (term-send-raw-string "\C-A")
    (end-of-line)))

(defun e-max-term-escape ()
  (interactive)
  (term-send-raw-string "\033"))
