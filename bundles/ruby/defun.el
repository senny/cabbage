(defvar e-max-ruby--last-project-root nil
  "cache for the project-root of the last executed spec-file")

(defvar e-max-ruby--last-spec-file nil
  "cache for the last executed spec-file")

(defun e-max-ruby-execute-test ()
  (interactive)
  (save-buffer)
  (if (and buffer-file-name (string-match "_spec.rb$" buffer-file-name))
      (progn
        (setq e-max-ruby--last-project-root (rspec-project-root))
        (setq e-max-ruby--last-spec-file buffer-file-name)
        (rspec-verify))
    (let ((default-directory e-max-ruby--last-project-root))
      (rspec-run-single-file e-max-ruby--last-spec-file))))
