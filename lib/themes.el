(defcustom cabbage-theme 'color-theme-lazy
  "The default theme-roller theme."
  :type 'symbol
  :group 'cabbage)

(cabbage-vendor 'color-theme)
(cabbage-vendor 'theme-roller)

(setq theme-roller-default-theme cabbage-theme)

(theme-roller-activate)
