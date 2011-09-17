(define-key read-expression-map (kbd "TAB") 'lisp-complete-symbol)
(define-key lisp-mode-shared-map (kbd "RET") 'reindent-then-newline-and-indent)
(define-key lisp-mode-shared-map (kbd "C-c v") 'eval-buffer)

(defun e-max-lisp-set-pairs ()
  (e-max--set-pairs '("(" "{" "[" "\"")))

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'e-max-lisp-set-pairs)
