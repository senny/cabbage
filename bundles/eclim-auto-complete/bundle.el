;;
;; Enables auto-completion in eclim using auto-complete-mode.
;;

(e-max-bundle 'eclim)

(require 'ac-emacs-eclim-source)
(add-hook 'eclim-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-emacs-eclim)))
