;; Configuration

(defcustom e-max-xml-flymake-enabled
  t
  "Enable flymake for xml mode."
  :type 'boolean
  :group 'e-max)


;;;; -------------------------------------
;;;; Bundle

(add-hook 'nxml-completion-hook 'rng-complete nil t)
(setq rng-nxml-auto-validate-flag t)
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.tld$" . nxml-mode))


(defun e-max-xml-set-pairs ()
  (e-max--set-pairs '("<" "{" "[" "\"" "\'")))

(add-hook 'nxml-mode-hook 'e-max-xml-set-pairs)


(defun e-max-xml-flymake ()
  (when (and e-max-xml-flymake-enabled (executable-find "xml"))
    (when (load "flymake" t)
      (e-max-flymake-init)

      (flymake-find-file-hook))))

(add-hook 'nxml-mode-hook 'e-max-xml-flymake)


