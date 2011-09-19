;; Configuration

;;;; -------------------------------------
;;;; Bundle

(defun move-cursor-next-pane ()
  "Move cursor to the next pane."
  (interactive)
  (other-window 1))

(defun move-cursor-previous-pane ()
  "Move cursor to the previous pane."
  (interactive)
  (other-window -1))

(global-unset-key (kbd "C-b")) ; backward-char
(global-unset-key (kbd "C-f")) ; forward-char
(global-unset-key (kbd "C-p")) ; previous-line
(global-unset-key (kbd "C-n")) ; next-line
(global-unset-key (kbd "C-M-i"))
(e-max-global-set-key (kbd "M-j") 'backward-char)
(e-max-global-set-key (kbd "M-l") 'forward-char)
(e-max-global-set-key (kbd "M-i") 'previous-line)
(e-max-global-set-key (kbd "M-I") 'scroll-down)
(e-max-global-set-key (kbd "M-C-i") 'scroll-down)
(e-max-global-set-key (kbd "M-k") 'next-line)
(e-max-global-set-key (kbd "M-K") 'scroll-up)
(e-max-global-set-key (kbd "M-C-k") 'scroll-up)
(e-max-global-set-key (kbd "M-L") 'end-of-line)
(e-max-global-set-key (kbd "M-C-l") 'end-of-line)
(e-max-global-set-key (kbd "M-J") 'beginning-of-line)
(e-max-global-set-key (kbd "M-C-j") 'beginning-of-line)

(global-unset-key (kbd "M-b")) ; backward-word
(global-unset-key (kbd "M-f")) ; forward-word
(e-max-global-set-key (kbd "M-u") 'backward-word)
(e-max-global-set-key (kbd "M-o") 'forward-word)
(e-max-global-set-key (kbd "M-U") 'backward-paragraph)
(e-max-global-set-key (kbd "M-O") 'forward-paragraph)
(e-max-global-set-key (kbd "M-C-o") 'forward-paragraph)
(e-max-global-set-key (kbd "M-C-u") 'backward-paragraph)
(e-max-global-set-key (kbd "M-b") 'pop-to-mark-command)

(global-unset-key (kbd "C-<backspace>")) ; backward-kill-word
(global-unset-key (kbd "M-d")) ; kill-word

(global-unset-key (kbd "C-d")) ; delete-char
(e-max-global-set-key (kbd "M-d") 'delete-backward-char)
(e-max-global-set-key (kbd "M-f") 'delete-char)
(e-max-global-set-key (kbd "<delete>") 'delete-char)

(global-unset-key (kbd "M-<")) ; beginning-of-buffer
(global-unset-key (kbd "M->")) ; end-of-buffer
(e-max-global-set-key (kbd "M-h") 'beginning-of-buffer)
(e-max-global-set-key (kbd "M-H") 'end-of-buffer)
(e-max-global-set-key (kbd "M-RET") 'e-max-next-line)

(global-unset-key (kbd "C-x 1")) ; delete-other-windows
(global-unset-key (kbd "C-x 0")) ; delete-window
(e-max-global-set-key (kbd "M-1") 'delete-other-windows)
(e-max-global-set-key (kbd "M-0") 'delete-window)
(e-max-global-set-key (kbd "M-2") 'split-window-vertically)
(e-max-global-set-key (kbd "M-3") 'split-window-horizontally)
(e-max-global-set-key (kbd "M-4") 'balance-windows)
(e-max-global-set-key (kbd "M-5") 'delete-other-windows)
(e-max-global-set-key (kbd "M-+") 'balance-windows)

(global-unset-key (kbd "M-x")) ; execute-extended-command
(e-max-global-set-key (kbd "M-a") 'execute-extended-command)
(e-max-global-set-key (kbd "M-e") 'shell-command)

(global-unset-key (kbd "C-d"))
(global-unset-key (kbd "C-w"))
(global-unset-key (kbd "C-s"))
(global-unset-key (kbd "C-a"))
(e-max-global-set-key (kbd "C-d") 'windmove-right)
(e-max-global-set-key (kbd "C-s") 'windmove-down)
(e-max-global-set-key (kbd "C-a") 'windmove-left)
(e-max-global-set-key (kbd "C-w") 'windmove-up)
(e-max-global-set-key (kbd "M-s") 'move-cursor-next-pane)
(e-max-global-set-key (kbd "M-S") 'move-cursor-previous-pane)

(global-unset-key (kbd "C-/")) ; undo
(global-unset-key (kbd "C-_")) ; undo
(e-max-global-set-key (kbd "M-z") 'undo)

(global-unset-key (kbd "C-SPC")) ; set-mark-command
(e-max-global-set-key (kbd "M-SPC") 'set-mark-command)
(e-max-global-set-key (kbd "M-S-SPC") 'mark-paragraph)

(global-unset-key (kbd "M-w")) ; kill-ring-save
(global-unset-key (kbd "C-y")) ; yank
(global-unset-key (kbd "M-y")) ; yank-pop
(global-unset-key (kbd "C-r")) ; yank-pop
(e-max-global-set-key (kbd "M-x") 'kill-region)
(e-max-global-set-key (kbd "M-c") 'kill-ring-save)
(e-max-global-set-key (kbd "M-v") 'yank)
(e-max-global-set-key (kbd "M-V") 'yank-pop)
(e-max-global-set-key (kbd "C-r d") 'kill-rectangle)

(global-unset-key (kbd "C-x C-f")) ; find-file
(global-unset-key (kbd "C-x h")) ; mark-whole-buffer
(global-unset-key (kbd "C-x C-w")) ; write-file
(e-max-global-set-key (kbd "C-o") 'find-file)
(e-max-global-set-key (kbd "C-S-n") 'write-file)
(e-max-global-set-key (kbd "C-S-a") 'mark-whole-buffer)

;; Help should search more than just commands
(e-max-global-set-key (kbd "C-h a") 'apropos)

;; general
(e-max-global-set-key (kbd "C-c e") 'eval-and-replace)
(e-max-global-set-key (kbd "C-x C-m") 'execute-extended-command)
(e-max-global-set-key (kbd "C-c C-m") 'execute-extended-command)
(e-max-global-set-key (kbd "M-r") 'replace-string)
(e-max-global-set-key [C-return] 'e-max-duplicate-line)
(e-max-global-set-key (kbd "C-$") 'e-max-kill-buffer)
(e-max-global-set-key (kbd "C-c i") 'indent-buffer)
(e-max-global-set-key (kbd "C-c n") 'e-max-cleanup-buffer)

(e-max-global-set-key (kbd "C-c C-k") 'e-max-comment-or-uncomment-region-or-line)
(e-max-global-set-key (kbd "C-c k") 'kill-compilation)

;;;; Searching

;; Use regex searches by default.
(global-unset-key (kbd "C-M-r")) ;; isearch-backwards
(e-max-global-set-key (kbd "C-f") 'isearch-forward-regexp)
(e-max-global-set-key (kbd "C-*") 'isearch-forward-at-point)

;; File finding
(e-max-global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(e-max-global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(e-max-global-set-key (kbd "C-c r") 'revert-buffer)

;;;; isearch
(define-key isearch-mode-map (kbd "M-s") 'move-cursor-next-pane)
(define-key isearch-mode-map (kbd "M-v") 'isearch-yank-kill)
(define-key isearch-mode-map (kbd "M-w") 'isearch-query-replace)
(define-key isearch-mode-map (kbd "M-o") 'isearch-yank-word)
(define-key isearch-mode-map (kbd "M-l") 'isearch-yank-char)
(define-key isearch-mode-map (kbd "M-j") 'isearch-delete-char)
(define-key isearch-mode-map (kbd "M-u") 'isearch-delete-char)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
;; TODO: find a suitable binding to use the search ring
;; (define-key isearch-mode-map (kbd "C-i") 'isearch-ring-retreat)
;; (define-key isearch-mode-map (kbd "C-k") 'isearch-ring-advance)
