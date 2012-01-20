(e-max-bindings-make-theme
 "ergonomic"

 (unset "C-p")
 (unset "C-r")

 (sticky "M-j" backward-char)
 (sticky "M-l" forward-char)
 (sticky "M-i" previous-line)
 (sticky "M-k" next-line)

 (sticky "M-J" beginning-of-line)
 (sticky "M-C-j" beginning-of-line)
 (sticky "M-L" end-of-line)
 (sticky "M-C-l" end-of-line)
 (sticky "M-I" scroll-down)
 (sticky "M-C-i" scroll-down)
 (sticky "M-K" scroll-up)
 (sticky "M-C-k" scroll-up)

 (sticky "M-u" backward-word)
 (sticky "M-o" forward-word)
 (sticky "M-U" backward-paragraph)
 (sticky "M-C-u" backward-paragraph)
 (sticky "M-O" forward-paragraph)
 (sticky "M-C-o" forward-paragraph)

 (sticky "M-h" beginning-of-buffer)
 (sticky "M-H" end-of-buffer)

 (sticky "M-1" e-max-enlargement-enlarge)
 (sticky "M-C-1" e-max-enlargement-restore)
 (sticky "M-0" delete-window)
 (sticky "M-2" split-window-vertically)
 (sticky "M-3" split-window-horizontally)
 (sticky "M-4" balance-windows)
 (sticky "M-+" balance-windows)
 (sticky "M-5" delete-other-windows)

 (sticky "C-d" windmove-right)
 (sticky "C-s" windmove-down)
 (sticky "C-a" windmove-left)
 (sticky "C-w" windmove-up)
 (sticky "M-s" move-cursor-next-pane)
 (sticky "M-S" move-cursor-previous-pane)

 (sticky "C-o" find-file)
 (sticky "C-c r" revert-buffer)

 (sticky "M-a" execute-extended-command)
 (sticky "C-x C-m" execute-extended-command)
 (sticky "C-c C-m" execute-extended-command)
 (sticky "M-q" shell-command)
 (sticky "M-e" e-max-testing-execute-test)
 (sticky "M-z" undo)
 (sticky "M-x" kill-region)
 (sticky "M-c" kill-ring-save)
 (sticky "M-v" yank)
 (sticky "M-V" yank-pop)
 (sticky "M-RET" e-max-next-line)

 (sticky "C-r d" kill-rectangle)
 (sticky "C-r y" yank-rectangle)
 (sticky "C-r i" string-rectangle)

 (sticky "C-p s" persp-switch)
 (sticky "C-p p" e-max-persp-last)
 (sticky "C-p d" persp-kill)
 (sticky "C-p x" persp-kill)
 (sticky "C-p m" e-max-persp-main)
 (sticky "C-p o" e-max-org-emacs-persp)
 (sticky "C-p e" e-max-emdeveloper-emacs-persp)
 (sticky "C-p t" e-max-terminal-open-term-persp)

 (sticky "M-d" delete-backward-char)
 (sticky "M-f" delete-char)
 (sticky "M-D" backward-kill-word)
 (sticky "M-F" kill-word)
 (sticky "<delete>" delete-char)

 (sticky "M-SPC" set-mark-command)
 (sticky "M-S-SPC" mark-paragraph)
 (sticky "M-C-SPC" mark-sexp)
 (sticky "C-S-a" mark-whole-buffer)
 (sticky "M-b" pop-to-mark-command)

 ;; TAB should be overrideable
 (global "TAB" e-max-smart-tab)
 (sticky "C-$" e-max-kill-buffer)
 (sticky "M-r" replace-string)
 (sticky "C-<return>" e-max-duplicate-line)
 (sticky "C-c C-k" e-max-comment-or-uncomment-region-or-line)
 (sticky "C-c k" kill-compilation)
 (sticky "C-f" isearch-forward-regexp)
 (sticky "C-c i" indent-buffer)
 (sticky "C-c n" e-max-cleanup-buffer)
 (sticky "C-x C-b" ibuffer)

 (sticky "C-h a" apropos)

 (sticky "C-c p" e-max-emdeveloper-find-e-max-config)

 (sticky "M-<up>" move-text-up)
 (sticky "M-<down>" move-text-down)
 (sticky "M-<right>" textmate-shift-right)
 (sticky "M-<left>" textmate-shift-left)
)

;; MISSING BINDINGS
;; (when (fboundp 'recentf-ido-find-file)
;;   (e-max-global-set-key (kbd "C-x f") 'recentf-ido-find-file))

;; ;;;; isearch
;; (define-key isearch-mode-map (kbd "M-s") 'move-cursor-next-pane)
;; (define-key isearch-mode-map (kbd "M-v") 'isearch-yank-kill)
;; (define-key isearch-mode-map (kbd "M-w") 'isearch-query-replace)
;; (define-key isearch-mode-map (kbd "M-o") 'isearch-yank-word)
;; (define-key isearch-mode-map (kbd "M-l") 'isearch-yank-char)
;; (define-key isearch-mode-map (kbd "M-j") 'isearch-delete-char)
;; (define-key isearch-mode-map (kbd "M-u") 'isearch-delete-char)
;; (define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
;; ;; TODO: find a suitable binding to use the search ring
;; ;; (define-key isearch-mode-map (kbd "C-i") 'isearch-ring-retreat)
;; ;; (define-key isearch-mode-map (kbd "C-k") 'isearch-ring-advance)
