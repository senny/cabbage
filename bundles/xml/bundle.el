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

;; automatically enable nxml-mode for various file types
(add-to-list 'auto-mode-alist
            (cons (concat "\\." (regexp-opt '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
                  'nxml-mode))

;; enable nxml-mode when the user starts typing an xml document
(setq magic-mode-alist
      (cons '("<\\?xml " . nxml-mode)
           magic-mode-alist))

;; enable automatic closing of tags
(setq nxml-slash-auto-complete-flag t)

(defun e-max-xml-set-pairs ()
  (e-max--set-pairs '("{" "[" "\"" "\'")))

(add-hook 'nxml-mode-hook 'e-max-xml-set-pairs)

(defun e-max-xml-flymake ()
  (when (and e-max-xml-flymake-enabled (executable-find "xml"))
    (when (load "flymake" t)
      (e-max-flymake-init)

      (flymake-find-file-hook))))

(add-hook 'nxml-mode-hook 'e-max-xml-flymake)

;; Rebind '>', so that it automatically inserts a closing xml tag (if
;; appropriate)
(defun e-max-nxml-end-tag ()
  (interactive)
  (if (eq (face-at-point) 'default)
      (condition-case nil
          (nxml-balanced-close-start-tag-inline)
        (error
         (insert ">")))
    (insert ">")))

(add-hook 'nxml-mode-hook
          (lambda ()
            ;; rebind > to close the current tag
            (define-key nxml-mode-map ">" 'e-max-nxml-end-tag)))



