
(defun cabbage-latex--enable-flymake ()
  (if (load "flymake" t)
      (progn

        ;; we need to patch flymake-get-tex-args after each load of flymake.
        ;; doing this only once and loading flymake afterwards may result in
        ;; crash of emacs in certain cases.
        (defun flymake-get-tex-args (file-name)
          (eval cabbage-latex--flymake-tex-args))

        (flymake-mode t)
        (cabbage-flymake-init))))

(defvar cabbage-latex--flymake-tex-args nil
  "quoted flymake arguments.")

(when (and cabbage-latex-enable-flymake
           (cond

            ;; allow user to set the args in his customizations
            (cabbage-latex--flymake-tex-args
             t)

            ;; use chktex
            (cabbage-latex-flymake-use-chktex
             (when (executable-find "chktex")

               (setq cabbage-latex--flymake-tex-args
                     '(list "chktex" (list "-q" "-v0" file-name)))
               t))

            ;; use texify
            ((executable-find "texify")
             (setq cabbage-latex--flymake-tex-args
                   '(list "texify" (list "--pdf"
                                         "--tex-option=-c-style-errors"
                                         file-name)))
             t))

           (add-hook 'latex-mode-hook 'cabbage-latex--enable-flymake)))
