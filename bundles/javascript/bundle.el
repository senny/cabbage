;;;; -------------------------------------
;;;; Bundle
(add-to-list 'auto-mode-alist '("\\.js\\(on\\)?$" . js-mode))

;; Setup
(defun cabbage-javascript-configure-indenting ()
  (setq js-indent-level 2
        javascript-indent-level 2
        js-auto-indent-flag nil))
(add-hook 'js-mode-hook 'cabbage-javascript-configure-indenting)

(defun cabbage-javascript-set-pairs ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "'")))
(add-hook 'js-mode-hook 'cabbage-javascript-set-pairs)

(defun cabbage-javascript-fix-fontlock ()
  (font-lock-add-keywords
   'js-mode
   '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):"
      1 font-lock-warning-face t)))

  (font-lock-add-keywords
   'js-mode `(("\\(function *\\)("
               (0 (progn (compose-region (match-beginning 1)
                                         (match-end 1) "ƒ")
                         nil))))))

(eval-after-load 'js
  '(progn
     (cabbage-javascript-fix-fontlock)))

(when (cabbage-flycheck-active-p)
  (cabbage-flycheck-init)
  (add-hook 'js-mode-hook 'cabbage-flycheck-keybindings)
  (add-hook 'js-mode-hook 'flycheck-mode))
