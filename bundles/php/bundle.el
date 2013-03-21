;;;; -------------------------------------
;;;; Php Bundle

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

  (defun cabbage-phpunit-first-readable-file (&rest paths)
    "Returns the first readable file in the list"
    (dolist (path paths)
      (when (file-readable-p path)
        (return path))))

  (defun cabbage-phpunit-command ()
    "Returns the phpunit command path (vendor/bin or bin/ because of composer)"
    (let ((path-to-phpunit-command
           (cabbage-phpunit-first-readable-file (cabbage-project-expand-path "vendor" "bin" "phpunit")
                                                (cabbage-project-expand-path "bin" "phpunit"))))
      (if path-to-phpunit-command
          path-to-phpunit-command
        "phpunit")))

  (defun cabbage-phpunit-config-file ()
    "Returns a given phpunit config file if exists (check app/ because of symfony default.)"
    (let ((path-to-phpunit-config
           (cabbage-phpunit-first-readable-file (cabbage-project-expand-path "app" "phpunit.xml")
                                                (cabbage-project-expand-path "phpunit.xml"))))
      (if path-to-phpunit-config
          (format "%s %s" "-c" path-to-phpunit-config)
        nil)))

  (defun cabbage-phpunit-default-options ()
    (cabbage-phpunit-config-file))

  (defun cabbage-phpunit-runner ()
    "Returns command line to run phpunit"
    (format "%s %s" (cabbage-phpunit-command) (cabbage-phpunit-default-options)))

  (defun cabbage-phpunit-run-single-file (filename)
    (compile (format "%s %s" (cabbage-phpunit-runner) filename)))

  (when (and buffer-file-name (string-match "Test.php$" buffer-file-name))
    (setq cabbage-testing-execute-function 'cabbage-phpunit-run-single-file)))

(when (cabbage-flymake-active-p)
  (cabbage-load-bundle-dependencies "php" '("flymake")))

(add-hook 'php-mode-hook 'cabbage-php-mode-hook)
