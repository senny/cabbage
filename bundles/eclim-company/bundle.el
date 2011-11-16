;;
;; Enables auto-completion in eclim using company-mode.
;;

(e-max-bundle 'eclim)
(e-max-bundle 'company)

(require 'company-emacs-eclim)

(company-emacs-eclim-setup)


