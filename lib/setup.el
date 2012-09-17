(defcustom cabbage-remove-trailing-whitespace t
  "Specify if trailing whitespaces should be removed when a file is saved.
When setting to t remove-trailing-whitespace-mode will be activated."
  :type 'boolean
  :group 'cabbage)

 (setq default-frame-alist
       '((top . 1) (left . 1)))

(when cabbage-remove-trailing-whitespace
  (add-hook 'cabbage-initialized-hook 'remove-trailing-whitespace-mode))

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
(defcustom cabbage-backup-dir
  (expand-file-name "~/.emacs.d/backup")
  "the location where emacs will store auto-save and backup files.")

(make-directory cabbage-backup-dir t)
(setq backup-by-copying t)
(setq auto-save-list-file-prefix
      (concat cabbage-backup-dir ".auto-saves-"))
(setq backup-directory-alist
      `((".*" . ,cabbage-backup-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,cabbage-backup-dir t)))

(dolist (vendor-dir cabbage-vendor-dirs)
  (add-to-list 'load-path vendor-dir))
