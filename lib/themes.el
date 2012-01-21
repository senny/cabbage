(defcustom e-max-theme 'color-theme-lazy
  "The default theme-roller theme."
  :type 'symbol
  :group 'e-max)

(load (concat e-max-vendor-dir "color-theme.el"))
(e-max-vendor 'theme-roller)

(setq theme-roller-default-theme e-max-theme)

(theme-roller-activate)
