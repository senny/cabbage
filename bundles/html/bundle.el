(e-max-bundle 'xml)


(add-to-list 'auto-mode-alist '("\\.html$" . nxml-mode))
(add-hook 'html-mode-hook 'e-max-xml-set-pairs)
