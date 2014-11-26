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

(defun cabbage-xml-set-pairs ()
  (cabbage--set-pairs '("{" "[" "\"" "\'")))

(add-hook 'nxml-mode-hook 'cabbage-xml-set-pairs)

;; Rebind '>', so that it automatically inserts a closing xml tag (if
;; appropriate)
(defun cabbage-nxml-end-tag ()
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
            (define-key nxml-mode-map ">" 'cabbage-nxml-end-tag)))

(when (cabbage-flycheck-active-p)
  (cabbage-flycheck-init)
  (add-hook 'nxml-mode-hook 'flycheck-mode)
  (add-hook 'nxml-mode-hook 'cabbage-flycheck-keybindings))
