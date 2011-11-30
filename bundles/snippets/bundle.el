;;
;; A bundle for code snippets using yasnippet.
;;
;; User-defined snippets are kept in ~/.emacs.d/snippets/. Create new
;; ones with yas/new-snippet
;;

(e-max-vendor 'yasnippet-bundle)

(defvar e-max-snippets--default-directory
  (expand-file-name "~/.emacs.d/snippets/")
  "Default snippets directory.")

(if (not (file-exists-p e-max-snippets--default-directory))
    (make-directory e-max-snippets--default-directory))

(setq yas/root-directory (list e-max-snippets--default-directory
                               (concat e-max-bundle-dir "snippets/")))
(yas/initialize)
(yas/reload-all)
