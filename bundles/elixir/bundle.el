(cabbage-vendor 'textmate)
(cabbage-vendor 'elixir-mode)
(cabbage-vendor 'alchemist)

;; add additional files / directories to execlude from textmate-goto-file
(when (not (string-match "deps" *textmate-gf-exclude*))
  (setq *textmate-gf-exclude*
        (replace-regexp-in-string "build"
                                  "build|_build|cover|deps"
                                  *textmate-gf-exclude*))

  (setq *textmate-project-roots*
        (append *textmate-project-roots* '("mix.exs"))))

(defun cabbage-elixir-mode-hook ()
  (cabbage--set-pairs '("(" "{" "[" "\"" "\'" "|"))

  (when (and buffer-file-name (string-match "_test.exs$" buffer-file-name))
    (setq cabbage-testing-execute-function 'alchemist-mix-test-file)))

(add-hook 'elixir-mode-hook 'cabbage-elixir-mode-hook)
