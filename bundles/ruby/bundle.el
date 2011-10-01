;; load the latest ruby-mode to get the syntax-higlighting working
(load (concat e-max-vendor-dir "ruby-mode"))


(e-max-vendor 'rhtml-mode)
(e-max-vendor 'yari)

(load (concat e-max-bundle-dir "ruby/defun"))

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

;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

(defun e-max-open-spec-other-buffer ()
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

(eval-after-load 'ruby-mode
  '(progn
     ;;;; Additional Libraries
     (e-max-vendor 'rspec-mode)
     (setq rspec-use-rvm t)
     (setq rspec-use-rake-flag nil)
     (setq rspec-spec-command "rspec")


     (e-max-vendor 'rvm)

     ;; active the default ruby configured with rvm
     (when (fboundp 'rvm-use-default)
       (rvm-use-default))

     (define-key ruby-mode-map (kbd "C-h r") 'yari)
     (define-key ruby-mode-map (kbd "C-c C-r g") 'rvm-open-gem)
     (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key ruby-mode-map (kbd "#") 'ruby-interpolate)
     (define-key ruby-mode-map (kbd "C-c , ,") 'e-max-open-spec-other-buffer)

     ;; disable TAB in ruby-mode-map, so that e-max-smart-tab is used
     (define-key ruby-mode-map (kbd "TAB") nil)

     ;; fix syntax highlighting for Cucumber Step Definition regexps
     (add-to-list 'ruby-font-lock-syntactic-keywords
                  '("\\(\\(\\)\\(\\)\\|Given\\|When\\|Then\\)\\s *\\(/\\)[^/\n\\\\]*\\(\\\\.[^/\n\\\\]*\\)*\\(/\\)"
                    (4 (7 . ?/))
                    (6 (7 . ?/))))
     ))

(when (e-max-flymake-active-p)
  (load (concat e-max-bundle-dir "ruby/flymake")))

(defun e-max-ruby-mode-hook ()
  (e-max--set-pairs '("(" "{" "[" "\"" "\'" "|"))
  ;; (local-set-key [return] 'ruby-reindent-then-newline-and-indent)

  (when (e-max-bundle-active-p 'completion)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-yasnippet))

    (make-local-variable 'ac-ignores)
    (add-to-list 'ac-ignores "end")))

(add-hook 'ruby-mode-hook 'e-max-ruby-mode-hook)

(global-set-key (kbd "M-e") 'e-max-ruby-execute-test)
