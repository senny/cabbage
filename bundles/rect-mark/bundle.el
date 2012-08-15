(load (concat e-max-vendor-dir "rect-mark"))

(e-max-global-set-key (kbd "C-x r M-SPC") 'rm-set-mark)
(e-max-global-set-key (kbd "C-x r M-x")   'rm-kill-region)
(e-max-global-set-key (kbd "C-x r M-c")   'rm-kill-ring-save)
(e-max-global-set-key (kbd "C-x r <down-mouse-1>") 'rm-mouse-drag-region)
