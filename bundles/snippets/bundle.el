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

(defun cabbage-snippets--load-snippets ()
  (dolist (active-bundle cabbage-bundles)
    (dolist (bundle-path (cabbage--bundle-path active-bundle))
      (let ((snippets-dir (concat (file-name-directory bundle-path) "snippets")))
        (when (file-directory-p snippets-dir)
          (add-to-list 'yas/root-directory snippets-dir)
          (message "Snippets loaded from %s" snippets-dir)))))
  (yas/reload-all))

(if (not (file-exists-p cabbage-snippets--default-directory))
    (make-directory cabbage-snippets--default-directory))

(setq yas/root-directory (list cabbage-snippets--default-directory
                               (concat cabbage-repository "bundles/snippets/")))
(yas/initialize)

(add-hook 'cabbage-initialized-hook 'cabbage-snippets--load-snippets)
