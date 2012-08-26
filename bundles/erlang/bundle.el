(let* ((erlang-dir "/usr/local/lib/erlang")
       (erlang-emacs-dir (concat erlang-dir "/lib/tools-2.6.6/emacs"))
       (erlang-bin-dir (concat erlang-dir "/bin")))
  (when (file-directory-p erlang-emacs-dir)
    ;; setup Erlang environment
    (setq load-path (cons erlang-emacs-dir load-path))
    (setq erlang-root-dir erlang-dir)
    (setq exec-path (cons erlang-bin-dir exec-path))

    (defun cabbage-erlang-mode-hook ()
      (require 'erlang-flymake)
      (local-set-key (kbd "C-c C-l") 'erlang-compile))

    ;; customizations
    (eval-after-load 'erlang
      (add-hook 'erlang-mode-hook 'cabbage-erlang-mode-hook))

    (require 'erlang-start)))
