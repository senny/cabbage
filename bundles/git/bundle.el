(cabbage-vendor 'cl-lib)
(cabbage-vendor 'dash)
(cabbage-vendor 'with-editor)
(add-to-list 'load-path (concat (cabbage-vendor-library-dir 'magit) "lisp/"))
(require 'magit)

;;;; Magit
(eval-after-load 'magit
  '(progn
     (define-key magit-popup-mode-map "\C-p" nil)))


;; A monkeypatch to cause annotate to ignore whitespace
(defun vc-git-annotate-command (file buf &optional rev)
  (let ((name (file-relative-name file)))
    (vc-git-command buf 0 name "blame" "-w" rev)))
