;;;; ruby electric end
;; this code was extracted and modified.
;; SOURCE: http://rinari.rubyforge.org/svn/trunk/test/lisp/ruby-electric.el

(defconst ruby-electric-expandable-do-re
  "do\\s-$")

(defcustom ruby-electric-simple-keywords-re
  "\\(def\\|if\\|class\\|module\\|unless\\|case\\|while\\|do\\|until\\|for\\|begin\\)"
  "*Regular expresion matching keywords for which closing 'end'
is to be inserted."
  :type 'regexp :group 'ruby-electric)

(defun cabbage-ruby-electric-code-at-point-p()
  (and cabbage-ruby-automatically-insert-end
       (let* ((properties (text-properties-at (point))))
         (and (null (memq 'font-lock-string-face properties))
              (null (memq 'font-lock-comment-face properties))))))

(defun cabbage-ruby-electric-space-can-be-expanded-p()
  (if (cabbage-ruby-electric-code-at-point-p)
      (let* ((ruby-electric-keywords-re
              (concat ruby-electric-simple-keywords-re "\\s-$"))
             (ruby-electric-single-keyword-in-line-re
              (concat "\\s-*" ruby-electric-keywords-re)))
        (save-excursion
          (backward-word 1)
          (or (looking-at ruby-electric-expandable-do-re)
              (and (looking-at ruby-electric-keywords-re)
                   (not (string= "do" (match-string 1)))
                   (progn
                     (beginning-of-line)
                     (looking-at ruby-electric-single-keyword-in-line-re))))))))

(defun cabbage-ruby-electric-space (arg)
  (interactive "P")
  (self-insert-command (prefix-numeric-value arg))
  (if (cabbage-ruby-electric-space-can-be-expanded-p)
      (save-excursion
        (ruby-indent-line t)
        (newline)
        (ruby-insert-end))))
