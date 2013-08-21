;; Configuration

(defcustom cabbage-ruby-automatically-insert-end t
  "Automatically insert 'end' after ruby keywords like class and module."
  :type 'boolean
  :group 'cabbage)

;;;; -------------------------------------
;;;; Bundle

;; load the latest ruby-mode to get the syntax-higlighting working
(cabbage-vendor 'ruby-mode)
(cabbage-vendor 'rhtml-mode)
(cabbage-vendor 'yari)
(cabbage-vendor 'inf-ruby)

(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.js.rjs$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.xml.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.json.jbuilder$" . ruby-mode))

;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

(defun cabbage-run-single-ruby-file (filename)
  (let* ((name (file-name-nondirectory (car (split-string filename))))
         (name-buffer (format "*%s*" name)))
    (if (get-buffer name-buffer)
        (kill-buffer name-buffer))
    (ruby-compilation-run filename)))

(defun cabbage-ruby-test-run-file (filename)
  (interactive (list(buffer-file-name)))
  (let* ((name-buffer "ruby-test")
         (name-buffer-full (format "*%s*" name-buffer))
         (project-root (cabbage-project-root (file-name-directory filename))))
    (display-buffer (get-buffer-create name-buffer-full))
    (with-current-buffer name-buffer-full
      (setq default-directory project-root)
      (erase-buffer))
    (display-buffer name-buffer-full)
    (ruby-compilation-do name-buffer (cons "ruby" (list filename)))))

(defun cabbage-open-spec-other-buffer ()
  (interactive)
  (when (featurep 'rspec-mode)
    (let ((source-buffer (current-buffer))
          (other-buffer (progn
                          (rspec-toggle-spec-and-target)
                          (current-buffer))))
      (switch-to-buffer source-buffer)
      (pop-to-buffer other-buffer))))

(defun ruby-interpolate ()
  "In a double quoted string, interpolate."
  (interactive)
  (insert "#")
  (when (and
         (looking-back "\".*")
         (looking-at ".*\""))
    (insert "{}")
    (backward-char 1)))

(defun ruby-insert-end ()
  (interactive)
  (insert "end")
  (ruby-indent-line t)
  (end-of-line))

(eval-after-load 'ruby-mode
  '(progn
     ;;;; Additional Libraries
     (cabbage-vendor 'rspec-mode)
     (setq rspec-use-rvm t)
     (setq rspec-use-rake-flag nil)
     (setq rspec-spec-command "rspec")
     (setq rspec-use-bundler-when-possible nil)

     (cabbage-vendor 'rvm)

     ;; active the default ruby configured with rvm
     (when (fboundp 'rvm-use-default)
       (rvm-use-default))

     (define-key ruby-mode-map (kbd "C-h r") 'yari)
     (define-key ruby-mode-map (kbd "C-c C-r g") 'rvm-open-gem)
     (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key ruby-mode-map (kbd "#") 'ruby-interpolate)
     (define-key ruby-mode-map (kbd "C-c , ,") 'cabbage-open-spec-other-buffer)

     (when cabbage-ruby-automatically-insert-end
       (cabbage-load-bundle-dependencies "ruby" '("electric_end"))
       (define-key ruby-mode-map " " 'cabbage-ruby-electric-space))

     ;; disable TAB in ruby-mode-map, so that cabbage-smart-tab is used
     (define-key ruby-mode-map (kbd "TAB") nil)

     ;; fix syntax highlighting for Cucumber Step Definition regexps
     (add-to-list 'ruby-font-lock-syntactic-keywords
                  '("\\(\\(\\)\\(\\)\\|Given\\|When\\|Then\\)\\s *\\(/\\)[^/\n\\\\]*\\(\\\\.[^/\n\\\\]*\\)*\\(/\\)"
                    (4 (7 . ?/))
                    (6 (7 . ?/))))
     ))

(when (cabbage-flymake-active-p)
  (cabbage-load-bundle-dependencies "ruby" '("flymake")))

(defun cabbage-ruby-mode-hook ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "|"))

  (when (and buffer-file-name (string-match "_spec.rb$" buffer-file-name))
    (setq cabbage-testing-execute-function 'rspec-run-single-file))

  (when (and buffer-file-name (string-match "_test.rb$" buffer-file-name))
    (setq cabbage-testing-execute-function 'cabbage-ruby-test-run-file))

  (when (cabbage-bundle-active-p 'completion)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-yasnippet))

    (when (eq cabbage-completion-framework 'auto-complete)
      (make-local-variable 'ac-ignores)
      (add-to-list 'ac-ignores "end"))))

(add-hook 'ruby-mode-hook 'cabbage-ruby-mode-hook)
