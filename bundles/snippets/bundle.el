;;
;; A bundle for code snippets using yasnippet.
;;
;; User-defined snippets are kept in ~/.emacs.d/snippets/. Create new
;; ones with yas/new-snippet
;;

(cabbage-vendor 'yasnippet-bundle)

(defvar cabbage-snippets--default-directory
  (expand-file-name "~/.emacs.d/snippets/")
  "Default snippets directory.")

(if (not (file-exists-p cabbage-snippets--default-directory))
    (make-directory cabbage-snippets--default-directory))

(setq yas/root-directory (list cabbage-snippets--default-directory
                               (concat cabbage-bundle-dir "snippets/")))
(yas/initialize)
(yas/reload-all)
