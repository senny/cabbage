(load (concat cabbage-vendor-dir "rect-mark"))

(defun cabbage-rectangle-replace-string (from-string to-string delimited startcol endcol)
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

(defun cabbage-kill-region-or-rm-kill-region-executor ()
  "Use rm-kill-region if rect-mark is active."
  (interactive)
  (if rm-mark-active
      (call-interactively 'rm-kill-region)
    (call-interactively 'kill-region)))

(defun cabbage-kill-ring-save-or-rm-kill-ring-save-executor ()
  "Use rm-king-region-save if rect-mark is active."
  (interactive)
  (if rm-mark-active
      (call-interactively 'rm-kill-ring-save)
    (call-interactively 'kill-ring-save)))
