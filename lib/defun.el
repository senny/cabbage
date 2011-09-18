(defun e-max--set-pairs (pairs)
  "Sets up handling of pair characters."
  (when (e-max-insert-pairs-p)
    (mapcar (lambda (pair)
              (local-set-key pair 'skeleton-pair-insert-maybe))
            pairs)
    (setq skeleton-pair t)))

(defun e-max-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(defun e-max-indent-buffer ()
  "Indent each nonblank line in the buffer. See `indent-region"
  (interactive)
  (indent-region (point-min) (point-max)))

(defun e-max-untabify-buffer ()
  "Convert all tabs in the buffer to multiple spaces. See `untabify`."
  (interactive)
  (untabify (point-min) (point-max)))

(defun e-max-cleanup-buffer ()
  "Perform task such as auto-indent, untabify and delete trailing whitespace
on the current buffer."
  (interactive)
  (e-max-indent-buffer)
  (e-max-untabify-buffer)
  (delete-trailing-whitespace))

(defun e-max-duplicate-line ()
  "duplicate the current line on the line below it."
  (interactive)
  (beginning-of-line)
  (copy-region-as-kill (point) (progn (end-of-line) (point)))
  (textmate-next-line)
  (yank)
  (beginning-of-line)
  (indent-according-to-mode))

(defun e-max-comment-or-uncomment-line (&optional lines)
  "Comment current line. Argument gives the number of lines
forward to comment"
  (interactive "P")
  (comment-or-uncomment-region
   (line-beginning-position)
   (line-end-position lines)))

(defun e-max-comment-or-uncomment-region-or-line (&optional lines)
  "If the line or region is not a comment, comments region
if mark is active, line otherwise. If the line or region
is a comment, uncomment."
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
        (comment-or-uncomment-region (point) (mark))
        )
    (e-max-comment-or-uncomment-line lines)))


;; for loading libraries in from the vendor directory
(setq e-max-vendor-dir (concat e-max-repository "vendor/"))
(defun e-max-vendor (library)
  (let* ((file (symbol-name library))
         (normal (concat e-max-vendor-dir file))
         (suffix (concat normal ".el")))
    (cond
     ((file-directory-p normal)
      (add-to-list 'load-path normal)
      (require library))
     ((file-directory-p suffix)
      (add-to-list 'load-path suffix)
      (require library))
     ((file-exists-p suffix)
      (require library)))))


(defun e-max-next-line ()
  "Inserts an indented newline after the current line and moves the point to it."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun e-max-ido-open-find-directory-files (directory)
  (let ((directory (concat (expand-file-name directory) "/")))
    (concat directory (ido-completing-read (concat directory ": ")
                                           (mapcar (lambda (path)
                                                     (replace-regexp-in-string (concat "^" (regexp-quote directory) "/") "" path))
                                                   (split-string
                                                    (shell-command-to-string
                                                     (concat
                                                      "find \"" directory
                                                      "\" -type f | grep -v \"/.git/\" | grep -v \"/.yardoc/\""))))))))
