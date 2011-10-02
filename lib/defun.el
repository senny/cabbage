(defun e-max--set-pairs (pairs)
  "Sets up handling of pair characters."
  (when (e-max-insert-pairs-p)
    (mapcar (lambda (pair)
              (local-set-key pair 'skeleton-pair-insert-maybe))
            pairs)
    (setq skeleton-pair t)))

(defun e-max--find-parent-with-file (path filename)
  "Traverse PATH upwards until we find FILENAME in the dir.
If we find it return the path of that dir, othwise nil is
returned."
  (if (file-exists-p (concat path "/" filename))
      path
    (let ((parent-dir (file-name-directory (directory-file-name path))))
      ;; Make sure we do not go into infinite recursion
      (if (string-equal path parent-dir)
          nil
        (e-max--find-parent-with-file parent-dir filename)))))

(defun e-max--expand-symlinks-recursively (path)
  "Follows symlinks of path and every parent directory."
  (let* ((realpath (or (file-symlink-p path) path))
         (parent (replace-regexp-in-string
                  "\/$" ""
                  (file-name-directory (directory-file-name realpath)))))
    (if (not (equal parent ""))
        (concat (e-max--expand-symlinks-recursively parent)
                (substring realpath (length parent)))
      realpath)))

(defun e-max-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

;; Taken from: http://www.emacswiki.org/emacs/TabCompletion#toc2
(defun e-max-smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))

      ;; When multiple indent positions of a line are possible (such as
      ;; often in python code), we need to reset this-command and
      ;; last-command so that cycling through positions is possible.
      ;; This makes e-max-smart-tab more transparent in this case.
      (if (eq this-command last-command)
          (let ((this-command 'indent-for-tab-command)
                (last-command 'indent-for-tab-command))
            (indent-for-tab-command))
        (indent-for-tab-command)))))

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
  (let ((directory (concat (replace-regexp-in-string "\/?$" "" (expand-file-name directory)) "/")))
    (concat directory (ido-completing-read (concat directory ": ")
                                           (mapcar (lambda (path)
                                                     (replace-regexp-in-string (concat "^" (regexp-quote directory) "/") "" path))
                                                   (split-string
                                                    (shell-command-to-string
                                                     (concat
                                                      "find \"" directory
                                                      "\" -type f | grep -v \"/.git/\" | grep -v \"/.yardoc/\""))))))))


(defun e-max-list-bundles ()
  "Show available and enabled list of bundles"
  (interactive)

  (let* ((bundles (directory-files (concat e-max-repository "bundles") nil "^[^.]"))
         (active (mapcar (lambda (e) (symbol-name e)) e-max-bundles))
         (inactive (delq nil (mapcar (lambda (e)
                                       (if (not (member e active))
                                           e))
                                     bundles))))

    (message (concat
              "e-max-bundles: \n"
              (concat "INACTIVE: " (mapconcat 'identity inactive ", "))
              "\n"
              (concat "ACTIVE: " (mapconcat 'identity active ", "))))))
