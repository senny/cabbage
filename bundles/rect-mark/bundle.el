(load (concat cabbage-vendor-dir "rect-mark"))

(defun rectangle-replace-string (from-string to-string delimited startcol endcol)
  "Search and replace a rectangle."
  (interactive
   (progn (barf-if-buffer-read-only)
          (let ((common
                 (query-replace-read-args
                  (concat "Query replace"
                          (if current-prefix-arg " word" "")
                          (if (and transient-mark-mode mark-active) " in region" ""))
                  nil)))
            (list (nth 0 common)
                  (nth 1 common)
                  (nth 2 common)
                  (region-beginning)
                  (region-end)))))

  (goto-char
   (apply-on-rectangle
    '(lambda (startcol endcol from-string to-string)
       (let ((startpoint (progn (move-to-column startcol t)
                                (point)))
             (endpoint (progn (move-to-column endcol t)
                              (point))))

         (replace-string from-string to-string t startpoint endpoint)))
    startcol endcol from-string to-string)))


(cabbage-global-set-key (kbd "C-x r M-SPC") 'rm-set-mark)
(cabbage-global-set-key (kbd "C-x r M-x")   'rm-kill-region)
(cabbage-global-set-key (kbd "C-x r M-c")   'rm-kill-ring-save)
(cabbage-global-set-key (kbd "C-x r M-r")   'rectangle-replace-string)
(cabbage-global-set-key (kbd "C-x r s")     'string-rectangle)
(cabbage-global-set-key (kbd "C-x r <down-mouse-1>") 'rm-mouse-drag-region)
