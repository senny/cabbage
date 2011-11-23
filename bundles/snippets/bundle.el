;;
;; A bundle for code snippets using yasnippet.
;;
;; User-defined snippets are kept in ~/.emacs.d/snippets/. Create new
;; ones with yas/new-snippet
;;

(e-max-vendor 'yasnippet-bundle)

(setq yas/root-directory (list "~/.emacs.d/snippets/"
                               (concat e-max-bundle-dir "snippets/")))
(yas/initialize)
(yas/reload-all)
