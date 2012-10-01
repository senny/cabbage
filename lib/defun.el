(defun cabbage--set-pairs (pairs)
  "Sets up handling of pair characters."
  (when (cabbage-insert-pairs-p)
    (mapcar (lambda (pair)
              (local-set-key pair 'skeleton-pair-insert-maybe))
            pairs)
    (setq skeleton-pair t)))

(defun cabbage--find-parent-with-file (path filename)
  "Traverse PATH upwards until we find FILENAME in the dir.
If we find it return the path of that dir, othwise nil is
returned."
  (if (file-exists-p (concat path "/" filename))
      path
    (let ((parent-dir (file-name-directory (directory-file-name path))))
      ;; Make sure we do not go into infinite recursion
      (if (string-equal path parent-dir)
          nil
        (cabbage--find-parent-with-file parent-dir filename)))))

(defun cabbage--expand-symlinks-recursively (path)
  "Follows symlinks of path and every parent directory."
  (let* ((realpath (or (file-symlink-p path) path))
         (parent (replace-regexp-in-string
                  "\/$" ""
                  (file-name-directory (directory-file-name realpath)))))
    (if (not (equal parent ""))
        (concat (cabbage--expand-symlinks-recursively parent)
                (substring realpath (length parent)))
      realpath)))

(defun cabbage-kill-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

;; Taken from: http://www.emacswiki.org/emacs/TabCompletion#toc2
(defun cabbage-smart-tab ()
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
      ;; This makes cabbage-smart-tab more transparent in this case.
      (if (eq this-command last-command)
          (let ((this-command 'indent-for-tab-command)
                (last-command 'indent-for-tab-command))
            (indent-for-tab-command))
        (indent-for-tab-command)))))

(defun cabbage-indent-buffer ()
  "Indent each nonblank line in the buffer. See `indent-region"
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cabbage-untabify-buffer ()
  "Convert all tabs in the buffer to multiple spaces. See `untabify`."
  (interactive)
  (untabify (point-min) (point-max)))

(defun cabbage-cleanup-buffer ()
  "Perform task such as auto-indent, untabify and delete trailing whitespace
on the current buffer."
  (interactive)
  (cabbage-indent-buffer)
  (cabbage-untabify-buffer)
  (delete-trailing-whitespace))

(defun cabbage-duplicate-line ()
  "duplicate the current line on the line below it."
  (interactive)
  (beginning-of-line)
  (copy-region-as-kill (point) (progn (end-of-line) (point)))
  (textmate-next-line)
  (yank)
  (beginning-of-line)
  (indent-according-to-mode))

(defun cabbage-comment-or-uncomment-line (&optional lines)
  "Comment current line. Argument gives the number of lines
forward to comment"
  (interactive "P")
  (comment-or-uncomment-region
   (line-beginning-position)
   (line-end-position lines)))

(defun cabbage-comment-or-uncomment-region-or-line (&optional lines)
  "If the line or region is not a comment, comments region
if mark is active, line otherwise. If the line or region
is a comment, uncomment."
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
        (comment-or-uncomment-region (point) (mark))
        )
    (cabbage-comment-or-uncomment-line lines)))

;; for loading libraries in from the vendor directory
(defun cabbage-vendor-library-dir (vendor)
  "Returns the vendor's directory, nil if vendor directory does not exists"
  (let ((vendor-name (symbol-name vendor)))
    (car (cabbage-filter 'file-directory-p
                         (mapcar (lambda (vendor-dir)
                                   (concat vendor-dir vendor-name "/"))
                                 cabbage-vendor-dirs)))))

(defun cabbage-vendor (library)
  (let* ((library-dir (cabbage-vendor-library-dir library)))
    (when (and library-dir (file-directory-p library-dir))
      (add-to-list 'load-path library-dir)
      (require library))))


(defun cabbage-next-line ()
  "Inserts an indented newline after the current line and moves the point to it."
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun cabbage-ido-open-find-directory-files (directory)
  (let ((directory (concat (replace-regexp-in-string "\/?$" "" (expand-file-name directory)) "/")))
    (concat directory (ido-completing-read (concat directory ": ")
                                           (mapcar (lambda (path)
                                                     (replace-regexp-in-string (concat "^" (regexp-quote directory) "/") "" path))
                                                   (split-string
                                                    (shell-command-to-string
                                                     (concat
                                                      "find \"" directory
                                                      "\" -type f | grep -v \"/.git/\" | grep -v \"/.yardoc/\""))))))))

(defun cabbage-filter (condp lst)
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

(defun cabbage-debug ()
  (interactive)
  (pop-to-buffer "*cabbage: Debug*")
  (delete-region (point-min) (point-max))
  (let ((cabbage-revision (shell-command-to-string
                         (concat "cd " cabbage-repository " && git log -1 --pretty=\"%H\" ")))
        (active-modes))
    (mapc (lambda (mode) (condition-case nil
                             (if (and (symbolp mode) (symbol-value mode))
                                 (add-to-list 'active-modes mode))
                           (error nil) ))
          minor-mode-list)

    (insert (concat "==================== DEBUG OUTPUT ====================\n\n"))

    (insert (concat "== General\n"))
    (insert "\t- Emacs version: ")
    (emacs-version t)
    (newline)
    (insert "\t- operating system: " (symbol-name system-type))
    (newline)

    (insert (concat "\n== cabbage\n"))
    (insert (concat "\t- revision: " cabbage-revision))
    (insert "\t- active bundles: ")
    (princ cabbage-bundles (current-buffer))
    (newline)

    (insert (concat "\n== Emacs"))
    (insert (concat "\n\t- active-minor-modes: "))
    (princ active-modes (current-buffer))

    (insert (concat "\n\t- pre-command-hook: "))
    (princ pre-command-hook (current-buffer))))
