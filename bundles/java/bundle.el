
(defcustom e-max-java-use-eclim t
  "Use eclim for managing java files."
  :type 'boolean
  :group 'e-max)

(defun e-max-java-init ()
  "Initialize the java bundle."

  (e-max-vendor 'java-mode-indent-annotations)

  (when e-max-java-use-eclim
    (add-to-list 'load-path (concat e-max-vendor-dir "eclim/vendor/"))
    (e-max-vendor 'eclim)

    (setq eclim-interactive-completion-function 'ido-completing-read)

    (setq help-at-pt-display-when-idle t)
    (setq help-at-pt-timer-delay 0.1)
    (help-at-pt-set-timer)

    (global-eclim-mode t)

    (case e-max-completion-framework
      ('auto-complete
       (require 'ac-emacs-eclim-source)
       (add-hook 'eclim-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-emacs-eclim))))
      ('company-mode
       (require 'company-emacs-eclim)
       (company-emacs-eclim-setup)))

    ;; If we are using the snippets bundle, append the eclim
    ;; yasnippets dir to the list of yasnippet directories
    (if (and eclim-use-yasnippet (e-max-bundle-active-p 'snippets))
        (add-hook 'e-max-initialized-hook
                  (lambda ()
                    (add-to-list 'yas/root-directory
                                 (concat e-max-vendor-dir "eclim/snippets/")
                                 t)
                    (yas/reload-all))))))

(e-max-java-init)