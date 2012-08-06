(defcustom e-max-remove-trailing-whitespace t
  "Specify if trailing whitespaces should be removed when a file is saved.
When setting to t remove-trailing-whitespace-mode will be activated."
  :type 'boolean
  :group 'e-max)

 (setq default-frame-alist
       '((top . 1) (left . 1)))

(when e-max-remove-trailing-whitespace
  (add-hook 'e-max-initialized-hook 'remove-trailing-whitespace-mode))

(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point nil
        ido-max-prospects 10))

;; use spaces instead of tabs
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; global location for emacs backup files
(defcustom e-max-backup-dir
  (expand-file-name "~/.emacs.d/backup")
  "the location where emacs will store auto-save and backup files.")

(make-directory e-max-backup-dir t)
(setq backup-by-copying t)
(setq auto-save-list-file-prefix
      (concat e-max-backup-dir ".auto-saves-"))
(setq backup-directory-alist
      `((".*" . ,e-max-backup-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,e-max-backup-dir t)))
