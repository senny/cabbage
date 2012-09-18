(cabbage-vendor 'maxframe)

(defcustom cabbage-accessibility-force-side-by-side-split nil
  "set if you want emacs to split vertically"
  :group 'cabbage
  :type 'boolean)

(defcustom cabbage-accessibility-show-line-numbers nil
  "set to t if you want to have the line-numbers on the left side of your buffers"
  :group 'cabbage
  :type 'boolean)

(cabbage-vendor 'idle-highlight-mode)
(cabbage-vendor 'popwin)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t))

(delete-selection-mode 1)
(transient-mark-mode 1)
(blink-cursor-mode 1)
(show-paren-mode 1)
(idle-highlight-mode 1)
(column-number-mode 1)

(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq use-dialog-box nil
      visible-bell t
      echo-keystrokes 0.1
      inhibit-startup-message t
      truncate-partial-width-windows nil
      gnuserv-frame (car (frame-list)))

(setq special-display-function 'popwin:special-display-popup-window)

(setq-default cursor-type '(bar . 2))
(setq-default indicate-empty-lines t)

(when cabbage-accessibility-force-side-by-side-split
  (setq split-height-threshold nil)
  (setq split-width-threshold 0))

(when cabbage-accessibility-show-line-numbers
  (global-linum-mode)
  (setq linum-format "%3d "))

;; include path names when two buffers are equally named
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(defalias 'yes-or-no-p 'y-or-n-p)


(defun increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height))))

  (if (cabbage-bundle-active-p 'maximize)
    (maximize-frame)))

(defun decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                (face-attribute 'default :height))))

  (if (cabbage-bundle-active-p 'maximize)
      (maximize-frame)))

;; Highlight the current line
(global-hl-line-mode t)
