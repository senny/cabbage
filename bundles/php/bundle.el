;;;; -------------------------------------
;;;; Bundle

;; load the latest php-mode to get the syntax-higlighting working
(cabbage-vendor 'php-mode)

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php3$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php4$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.phps$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.phtml$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.module$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(defun cabbage-php-mode-hook ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "|"))

  (when (and buffer-file-name (string-match "Test.php$" buffer-file-name))
    (setq cabbage-testing-execute-function 'cabbage-phpunit-run-single-file))

  (defun cabbage-phpunit-run-single-file (filename)
    (compile (format "%s %s" "phpunit" filename))))

(when (cabbage-flymake-active-p)
  (cabbage-load-bundle-dependencies "php" '("flymake")))

(add-hook 'php-mode-hook 'cabbage-php-mode-hook)
