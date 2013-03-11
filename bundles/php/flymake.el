(eval-after-load 'php-mode
  '(progn
     ;; Libraries
     (require 'flymake)

     ;; Invoke php with '-l' to get syntax checking
     (defun flymake-php-init ()
       (let* ((temp (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
              (local (file-relative-name temp (file-name-directory buffer-file-name))))
         (list "php" (list "-f" local "-l"))))

     (push '("\\(Parse\\|Fatal\\) error: +\\(.*?\\) in \\(.*?\\) on line \\([0-9]+\\)$" 3 4 nil 2)
           flymake-err-line-patterns)

     (push '(".+\\.php[345s]?$" flymake-php-init) flymake-allowed-file-name-masks)
     (push '(".+\\.inc$" flymake-php-init) flymake-allowed-file-name-masks)
     (push '(".+\\.module$" flymake-php-init) flymake-allowed-file-name-masks)

     (add-hook 'php-mode-hook 'cabbage-flymake-init)

     (add-hook 'php-mode-hook
               (lambda ()
                 (when (and buffer-file-name
                            (file-writable-p
                             (file-name-directory buffer-file-name))
                            (file-writable-p buffer-file-name)
                            (if (fboundp 'tramp-list-remote-buffers)
                                (not (subsetp
                                      (list (current-buffer))
                                      (tramp-list-remote-buffers)))
                              t))
                   (local-set-key (kbd "C-c d")
                                  'flymake-display-err-menu-for-current-line)
                   (flymake-mode t))))))
