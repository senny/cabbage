(add-to-list 'load-path (concat e-max-vendor-dir "eclim/vendor/"))
(e-max-vendor 'eclim)

(setq eclim-interactive-completion-function 'ido-completing-read)

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

(global-eclim-mode)


