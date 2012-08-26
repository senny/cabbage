
(defcustom cabbage-java-use-eclim t
  "Use eclim for managing java files."
  :type 'boolean
  :group 'cabbage)

(defun cabbage-java-init ()
  "Initialize the java bundle."

  (cabbage-vendor 'java-mode-indent-annotations)
  (add-hook 'java-mode-hook 'java-mode-indent-annotations-setup)

  (when cabbage-java-use-eclim
    (add-to-list 'load-path (concat cabbage-vendor-dir "eclim/vendor/"))
    (cabbage-vendor 'eclim)

    (setq eclim-interactive-completion-function 'ido-completing-read)

    (setq help-at-pt-display-when-idle t)
    (setq help-at-pt-timer-delay 0.1)
    (help-at-pt-set-timer)

    (global-eclim-mode t)

    (case cabbage-completion-framework
      ('auto-complete
       (require 'ac-emacs-eclim-source)
       (add-hook 'eclim-mode-hook (lambda ()
                                    (add-to-list 'ac-sources 'ac-source-emacs-eclim)
                                    (add-to-list 'ac-sources 'ac-source-emacs-eclim-c-dot))))
      ('company-mode
       (require 'company-emacs-eclim)
       (company-emacs-eclim-setup)))

    ;; If we are using the snippets bundle, append the eclim
    ;; yasnippets dir to the list of yasnippet directories
    (if (and eclim-use-yasnippet (cabbage-bundle-active-p 'snippets))
        (add-hook 'cabbage-initialized-hook
                  (lambda ()
                    (let ((dir (concat cabbage-vendor-dir "eclim/snippets/")))
                      (add-to-list 'yas/root-directory dir t)
                      (yas/load-directory dir)))))))

(cabbage-java-init)
