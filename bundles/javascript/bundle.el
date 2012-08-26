;; Configuration

(defcustom cabbage-javascript-jslint-enabled nil
  "Enable flymake with jslint"
  :type 'boolean
  :group 'cabbage)

(defcustom cabbage-javascript-jslint-executable-path
  (or (executable-find "jsl")
      (concat cabbage-repository "bin/jsl-0.3.0-mac/jsl"))
  "path to the js-lint executable"
  :type 'string
  :group 'cabbage)

;;;; -------------------------------------
;;;; Bundle
(add-to-list 'auto-mode-alist '("\\.js\\(on\\)?$" . js-mode))


;; Defuns

(defun cabbage-javascript-jslint-compile ()
  (interactive)
  (compile (format "%s -process %s" cabbage-javascript-jslint-executable-path (buffer-file-name))))

;; Setup

(defun cabbage-javascript-keybindings ()
  (local-set-key (kbd "C-§") 'flymake-goto-next-error))
(add-hook 'js-mode-hook 'cabbage-javascript-keybindings)


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


(defun cabbage-javascript--configure-jslint ()
  (when (executable-find cabbage-javascript-jslint-executable-path)
    (require 'flymake)
    (defun cabbage-javascript-flymake-jslint-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list cabbage-javascript-jslint-executable-path
              (list "-process" local-file))))

    (setq flymake-allowed-file-name-masks
          (cons '(".+\\.js$"
                  cabbage-javascript-flymake-jslint-init
                  flymake-simple-cleanup
                  flymake-get-real-file-name)
                flymake-allowed-file-name-masks))

    (setq flymake-err-line-patterns
          (cons '("^Lint at line \\([[:digit:]]+\\) character \\([[:digit:]]+\\): \\(.+\\)$"
                  nil 1 2 3)
                flymake-err-line-patterns))

    (defun cabbage-javascript-enable-flymake-mode ()
      (if (executable-find cabbage-javascript-jslint-executable-path)
          (flymake-mode t)))
    (add-hook 'js-mode-hook 'cabbage-javascript-enable-flymake-mode)

    (add-hook 'js-mode-hook 'cabbage-flymake-init)))

(eval-after-load 'js
  '(progn
     (when cabbage-javascript-jslint-enabled
       (cabbage-javascript--configure-jslint))))


(eval-after-load 'mode-compile
  '(progn
     (add-to-list 'mode-compile-modes-alist '(js-mode . (senny-jslint-compile kill-compilation)))))
