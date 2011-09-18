(e-max-vendor 'auto-complete)
(e-max-vendor 'smex)

;;;; Smex Completion for M-x
(smex-initialize)

(defun e-max-smex-bind-keys ()
  (when (e-max-bundle-active-p 'ergonomic)
    (global-unset-key (kbd "M-a"))
    (global-set-key (kbd "M-a") 'smex)))
(add-hook 'e-max-initialized-hook 'e-max-smex-bind-keys)

;;;; Global IDO Completion
(ido-everywhere t)

;; Replace completing-read wherever possible, unless directed otherwise
(defadvice completing-read (around use-ido-when-possible activate)
  "If `ido-everywhere' is t, then use `ido-completing-read' wherever possible.
Even some places where ido doesn't already enable it."
  (if (or (not ido-mode)
          (not ido-everywhere)
          (boundp 'ido-cur-item)) ; Avoid infinite loop from ido calling completing-read
      ad-do-it
    (let ((allcomp (all-completions "" collection predicate)))
      (if allcomp
          (setq ad-return-value
                (ido-completing-read prompt
                                     allcomp
                                     nil require-match initial-input hist def))
        ad-do-it))))

;;;; AutoComplete
(require 'auto-complete-config)
(ac-config-default)

(setq ac-ignore-case nil)
