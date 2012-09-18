;; Configuration

(defcustom cabbage-terminal-fix-keys t
  "Replace default multi-term binding fixes with
cabbage bindings.")



;;;; -------------------------------------
;;;; Bundle

;; dependencies
(require 'term)
(require 'cl)
(require 'advice)
(cabbage-vendor 'multi-term)

;; customizations

(if (not multi-term-program)
    (setq multi-term-program "/bin/zsh"))

(when cabbage-terminal-fix-keys
  (setq term-bind-key-alist
        '(
          ;; provide some needed functions on other bindings, since they
          ;; conflict with emacs bindings
          ("C-c C-c" . term-interrupt-subjob)
          ("C-c C-d" . term-send-raw)
          ("C-c <escape>" . cabbage-term-escape)
          ("C-<escape>" . cabbage-term-escape)

          ;; movement
          ("M-i" . cabbage-term-up)  ;; move up - but dont tell terminal
          ("M-k" . cabbage-term-down) ;; move down - dont tell terminal
          ("M-C-i" . term-send-up) ;; tell terminal to move up (history)
          ("M-C-k" . term-send-down) ;; tell terminal to move down (history)

          ("M-j" . cabbage-term-backward-char)
          ("M-l" . cabbage-term-forward-char)
          ("M-L" . cabbage-term-end-of-line)
          ("M-C-l" . cabbage-term-end-of-line)
          ("M-J" . cabbage-term-beginning-of-line)
          ("M-C-j" . cabbage-term-beginning-of-line)
          ("M-u" . cabbage-term-backward-word) ;; backward-word
          ("M-o" . cabbage-term-forward-word) ;; forward-word

          ;; searching
          ("C-f" . isearch-forward)

          ;; modifying
          ("M-d" . cabbage-term-send-backspace)
          ("M-f" . term-send-del)
          ("<delete>" . term-send-del)
          ("<backspace>" . cabbage-term-send-backspace)
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

(defun cabbage-terminal-open-term-persp ()
  (interactive)

  (cabbage-persp "@terminal"
               (multi-term-next)))

(defun cabbage-terminal--input-possible-at-row ()
  "Returns t if the emacs-cursor is at a point where the shell allows
input. This is usually the case when the emacs-cursor is at the same
row as the terminal-cursor."
  (eq term-current-row (- (line-number-at-pos) 1)))

;; XXX: should be improved, especially for multi-line prompts.
(defun cabbage-terminal--cursor-in-prompt ()
  "Returns t if the cursor is in the prompt area. This is usually the
case when it is at the last line."
  (eq (buffer-end 1) (line-end-position 2)))


;; fixed binding funs

(defun cabbage-term-up ()
  (interactive)
  (cond ((cabbage-terminal--cursor-in-prompt) (previous-line))
        ((cabbage-terminal--input-possible-at-row) (term-send-up))
        ((previous-line))))

(defun cabbage-term-down ()
  (interactive)
  (cond ((cabbage-terminal--cursor-in-prompt) (next-line))
        ((cabbage-terminal--input-possible-at-row) (term-send-down))
        ((next-line))))

(defun cabbage-term-backward-char ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-left)
    (backward-char)))

(defun cabbage-term-forward-char ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-right)
    (forward-char)))

(defun cabbage-term-backward-word ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-backward-word)
    (backward-word)))

(defun cabbage-term-forward-word ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-forward-word)
    (forward-word)))

(defun cabbage-term-end-of-line ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-raw-string "\C-E")
    (end-of-line)))

(defun cabbage-term-beginning-of-line ()
  (interactive)
  (if (cabbage-terminal--input-possible-at-row)
      (term-send-raw-string "\C-A")
    (beginning-of-line)))

(defun cabbage-term-escape ()
  (interactive)
  (term-send-raw-string "\033"))

(defun cabbage-term-send-backspace ()
  (interactive)
  ;; term-mode send "\C-?" as backspace by default,
  ;; but it seems to not work properly in vim, so we fix it.
  (term-send-raw-string "\C-H"))
