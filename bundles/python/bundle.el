(defun e-max-python-set-pairs ()
  (e-max--set-pairs '("(" "{" "[" "\"" "\'" "`")))

(add-hook 'python-mode-hook 'e-max-python-set-pairs)


(defun e-max-python-keybindings ()
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-§") 'flymake-goto-next-error))

(add-hook 'python-mode-hook 'e-max-python-keybindings)


(when (executable-find "pyflakes")
  (defun e-max-python-flymake ()
    (when (load "flymake" t)

      (defun flymake-pyflakes-init ()
        (let* ((temp-file (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
               (local-file (file-relative-name
                            temp-file
                            (file-name-directory buffer-file-name))))
          (list (executable-find "pyflakes") (list local-file))))

      (add-to-list 'flymake-allowed-file-name-masks
                   '("\\.py\\'" flymake-pyflakes-init)))

    (add-hook 'find-file-hook 'flymake-find-file-hook))

  (add-hook 'python-mode-hook 'e-max-python-flymake)
  (add-hook 'python-mode-hook 'e-max-flymake-init))
