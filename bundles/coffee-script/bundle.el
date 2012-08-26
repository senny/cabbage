(cabbage-vendor 'coffee-mode)

(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(add-hook 'coffee-mode-hook '(lambda ()
                               (and (file-exists-p (buffer-file-name))
                                    (file-exists-p (coffee-compiled-file-name))
                                    (coffee-cos-mode t))))
