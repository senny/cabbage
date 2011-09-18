(defun e-max--set-pairs (pairs)
  "Sets up handling of pair characters."
  (mapcar (lambda (pair)
            (local-set-key pair 'skeleton-pair-insert-maybe))
          pairs)
  (setq skeleton-pair t))

(defun e-max-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

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
    (comment-or-uncomment-line lines)))


;; for loading libraries in from the vendor directory
(defun e-max-vendor (library)
  (let* ((file (symbol-name library))
         (normal (concat e-max-repository "vendor/" file))
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
