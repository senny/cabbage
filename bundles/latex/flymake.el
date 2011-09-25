
(defun e-max-latex--enable-flymake ()
  (if (load "flymake" t)
      (progn

        ;; we need to patch flymake-get-tex-args after each load of flymake.
        ;; doing this only once and loading flymake afterwards may result in
        ;; crash of emacs in certain cases.
        (defun flymake-get-tex-args (file-name)
          (eval e-max-latex--flymake-tex-args))

        (flymake-mode t)
        (e-max-flymake-init))))

(defvar e-max-latex--flymake-tex-args nil
  "quoted flymake arguments.")

(when (and e-max-latex-enable-flymake
           (cond

            ;; allow user to set the args in his customizations
            (e-max-latex--flymake-tex-args
             t)

            ;; use chktex
            (e-max-latex-flymake-use-chktex
             (when (executable-find "chktex")

               (setq e-max-latex--flymake-tex-args
                     '(list "chktex" (list "-q" "-v0" file-name)))
               t))

            ;; use texify
            ((executable-find "texify")
             (setq e-max-latex--flymake-tex-args
                   '(list "texify" (list "--pdf"
                                         "--tex-option=-c-style-errors"
                                         file-name)))
             t))

           (add-hook 'latex-mode-hook 'e-max-latex--enable-flymake)))
