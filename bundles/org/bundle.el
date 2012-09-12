(defcustom cabbage-org-files
  nil
  "the directory, where your org-mode files are located"
  :group 'cabbage
  :type 'string)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(when cabbage-org-files
  (setq org-agenda-files (directory-files cabbage-org-files t "^[^.].*")))

(setq org-log-done t
      org-clock-persist t
      org-clock-out-when-done nil
      org-agenda-clockreport-parameter-plist '(:link nil :maxlevel 4 :emphasize t))

(org-clock-persistence-insinuate)

(defun cabbage-org-emacs-persp ()
  (interactive)
  (cabbage-persp "@org"
               (find-file (first org-agenda-files))))

(defun cabbage-org-mode-hook ()
  (cabbage--set-pairs '("(" "{" "[" "\""))
  (auto-fill-mode 1))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)    ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(add-hook 'org-mode-hook 'cabbage-org-mode-hook)

(eval-after-load 'org
  '(progn
     (define-key org-mode-map (kbd "C-c a") 'org-agenda)
     (define-key org-mode-map (kbd "C-c t u") 'org-clock-update-time-maybe)
     (define-key org-mode-map (kbd "C-c t g") 'org-clock-goto)))
