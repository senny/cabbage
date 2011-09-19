;; Configuration

(defcustom e-max-plone-enable-po-mode
  t
  "Use po-mode for translation files"
  :type 'boolean
  :group 'e-max)


;;;; -------------------------------------
;;;; Bundle

(when e-max-plone-enable-po-mode
  (e-max-vendor 'po-mode)

  (add-to-list 'auto-mode-alist '("\\.po\\(t\\)?$" . po-mode)))

(add-to-list 'auto-mode-alist '("\\.\\(z\\)?pt$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.zcml$" . nxml-mode))
