;; Configuration

(defcustom e-max-javascript-jslint-enabled t
  "Enable flymake with jslint"
  :type 'boolean
  :group 'e-max)

(defcustom e-max-javascript-jslint-executable-path
  (or (executable-find "jsl")
      (concat e-max-repository "bin/jsl-0.3.0-mac/jsl"))
  "path to the js-lint executable"
  :type 'string
  :group 'e-max)

;;;; -------------------------------------
;;;; Bundle
(add-to-list 'auto-mode-alist '("\\.js\\(on\\)?$" . js-mode))


;; Defuns

(defun e-max-javascript-jslint-compile ()
  (interactive)
  (compile (format "%s -process %s" e-max-javascript-jslint-executable-path (buffer-file-name))))

;; Setup

(defun e-max-javascript-keybindings ()
  (local-set-key (kbd "C-§") 'flymake-goto-next-error))
(add-hook 'js-mode-hook 'e-max-javascript-keybindings)


(defun e-max-javascript-configure-indenting ()
  (setq js-indent-level 2
        javascript-indent-level 2
        js-auto-indent-flag nil))
(add-hook 'js-mode-hook 'e-max-javascript-configure-indenting)


(defun e-max-javascript-set-pairs ()
  (e-max--set-pairs '("(" "{" "[" "\"" "'")))
(add-hook 'js-mode-hook 'e-max-javascript-set-pairs)


(defun e-max-javascript-fix-fontlock ()
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
     (e-max-javascript-fix-fontlock)))


(defun e-max-javascript--configure-jslint ()
  (when (executable-find e-max-javascript-jslint-executable-path)
    (require 'flymake)
    (defun e-max-javascript-flymake-jslint-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list e-max-javascript-jslint-executable-path
              (list "-process" local-file))))

    (setq flymake-allowed-file-name-masks
          (cons '(".+\\.js$"
                  e-max-javascript-flymake-jslint-init
                  flymake-simple-cleanup
                  flymake-get-real-file-name)
                flymake-allowed-file-name-masks))

    (setq flymake-err-line-patterns
          (cons '("^Lint at line \\([[:digit:]]+\\) character \\([[:digit:]]+\\): \\(.+\\)$"
                  nil 1 2 3)
                flymake-err-line-patterns))

    (defun e-max-javascript-enable-flymake-mode ()
      (if (executable-find e-max-javascript-jslint-executable-path)
          (flymake-mode t)))
    (add-hook 'js-mode-hook 'e-max-javascript-enable-flymake-mode)

    (add-hook 'js-mode-hook 'e-max-flymake-init)))

(eval-after-load 'js
  '(progn
     (when e-max-javascript-jslint-enabled
       (e-max-javascript--configure-jslint))))


(eval-after-load 'mode-compile
  '(progn
     (add-to-list 'mode-compile-modes-alist '(js-mode . (senny-jslint-compile kill-compilation)))))
