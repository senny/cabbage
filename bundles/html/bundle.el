(cabbage-load-bundle 'xml)


(add-to-list 'auto-mode-alist '("\\.html$" . nxml-mode))
(add-hook 'html-mode-hook 'cabbage-xml-set-pairs)
