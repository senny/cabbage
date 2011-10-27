(defcustom e-max-project-location
  (expand-file-name "~/Projects/")
  "the location, where your development projects are stored locally"
  :type 'string
  :group 'e-max)

(defcustom e-max-project-find-file-function
  (if ido-mode 'ido-find-file 'find-file)
  "The function which is used by the project bundle to open files"
  :group 'e-max
  :type 'function)

(require 'recentf)

(setq recentf-exclude '(".emacsregisters.el" ".ido.last")
      recentf-max-saved-items 200)

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(recentf-mode t)

(defun e-max-project-ido-find-project ()
  (interactive)
  (let ((project-name (ido-completing-read "Project: "
                                           (directory-files e-max-project-location nil "^[^.]"))))
    (e-max-persp project-name)
    (let ((default-directory (concat e-max-project-location project-name)))
      (call-interactively e-max-project-find-file-function))))


(global-set-key (kbd "C-x p") 'e-max-project-ido-find-project)


(e-max-vendor 'textmate)
(global-set-key (kbd "M-t") 'textmate-goto-file)
(global-set-key (kbd "M-w") 'textmate-goto-symbol)
