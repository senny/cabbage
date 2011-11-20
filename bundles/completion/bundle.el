(defcustom e-max-completion-framework nil
  "Decide which completion framework (if any) you prefer to
  use with emacs."
  :group 'e-max
  :type '(choice (const :tag "none" nil)
                 (const :tag "auto-complete" auto-complete)
                 (const :tag "company-mode" company-mode)))

(defcustom e-max-completion-trigger 1
  "Key binding that triggers completion."
  :group 'e-max
  :type '(choice (const :tag "None" nil)
                 (const :tag "Ctrl+Space" 1)
                 (const :tag "Alt-/" 2)))

(defun e-max-complete ()
  (interactive)
  "Common completion function that calls the corresponding
function in the chosen completion framework."
  (case e-max-completion-framework
    ('auto-complete (auto-complete))
    ('company-mode (company-complete))
    (nil (dabbrev-expand))))

(defun e-max-completion-init ()
  "Initialize e-max completion"
  (case e-max-completion-framework
    ('auto-complete
     ;; auto-complete-init
     (message "loading auto-complete")
     (e-max-vendor 'auto-complete)
     (require 'auto-complete-config)
     (ac-config-default)
     (setq ac-ignore-case nil)
     (setq ac-delay 0.5)
     ;; enable auto-complete for additional modes
     (setq ac-modes (append ac-modes '(conf-unix-mode haml-mode))))
    ('company-mode
     ;; company-mode init
     (e-max-vendor 'company)
     (global-company-mode)))
  (case e-max-completion-trigger
    (1 (global-set-key [?\C- ] 'e-max-complete))
    (2 (define-key esc-map "/" 'e-max-complete))))

(e-max-completion-init)

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
