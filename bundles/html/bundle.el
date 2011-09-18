;; nxml
(add-hook 'nxml-completion-hook 'rng-complete nil t)
(setq rng-nxml-auto-validate-flag t)
(add-to-list 'auto-mode-alist '("\\.html$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.tld$" . nxml-mode))


(defun e-max-html-set-pairs ()
  (e-max--set-pairs '("<" "{" "[" "\"" "\'")))


(add-hook 'html-mode-hook 'e-max-html-set-pairs)
(add-hook 'nxml-mode-hook 'e-max-html-set-pairs)
