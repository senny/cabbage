(defcustom cabbage-project-location
  (expand-file-name "~/Projects/")
  "the location, where your development projects are stored locally"
  :type 'string
  :group 'cabbage)

(defcustom cabbage-project-find-file-function
  (if ido-mode 'ido-find-file 'find-file)
  "The function which is used by the project bundle to open files"
  :group 'cabbage
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

(defun cabbage-project-ido-find-project ()
  (interactive)
  (let ((project-name (ido-completing-read "Project: "
                                           (directory-files cabbage-project-location nil "^[^.]"))))
    (cabbage-persp project-name)
    (let ((default-directory (concat cabbage-project-location project-name)))
      (call-interactively cabbage-project-find-file-function))))

(cabbage-vendor 'textmate)
