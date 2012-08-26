(defvar cabbage-enlargement--window-configuration-store nil
  "Hash storing window configurations. persp-name -> list of configs.")

(defvar cabbage-enlargement--curr-conf-history nil
  "Temporary used list of configs when walking back the history.")

(defun cabbage-enlargement--create-winconfig-store-if-nil ()
  (if (eq cabbage-enlargement--window-configuration-store nil)
      (setq cabbage-enlargement--window-configuration-store (make-hash-table :test 'equal :size 10))))

(defun cabbage-enlargement--get-winconfigs-of-current-persp ()
  (cabbage-enlargement--create-winconfig-store-if-nil)

  (let* ((persp (persp-name persp-curr))
         (configs (gethash persp cabbage-enlargement--window-configuration-store)))
    (if (eq configs nil)
        '()
      configs)))

(defun cabbage-enlargement--set-winconfigs-of-current-persp (configs)
  (cabbage-enlargement--create-winconfig-store-if-nil)

  (let ((persp (persp-name persp-curr)))
    (puthash persp configs cabbage-enlargement--window-configuration-store)))

(defun cabbage-enlargement--get-current-winconfig ()
  (list (current-frame-configuration) (current-window-configuration)))

(defun cabbage-enlargement--apply-winconfig (cfg)
  (set-frame-configuration (car cfg))
  (set-window-configuration (car (cdr cfg))))

(defun cabbage-enlargement-enlarge ()
  (interactive)

  (unless (= (count-windows nil) 1)
    (unless (or (eq last-command 'cabbage-enlargement-enlarge)
                (eq last-command 'cabbage-enlargement-restore))
      (cabbage-enlargement--set-winconfigs-of-current-persp
       (cons (cabbage-enlargement--get-current-winconfig)
             (cabbage-enlargement--get-winconfigs-of-current-persp))))
    (delete-other-windows)))

(defun cabbage-enlargement-restore ()
  (interactive)

  (if (eq last-command 'cabbage-enlargement-restore)
      (if (not cabbage-enlargement--curr-conf-history)
          (message "Top reached: no more configurations to restore.")
        (cabbage-enlargement--apply-winconfig (pop cabbage-enlargement--curr-conf-history)))

    (let ((configs (cabbage-enlargement--get-winconfigs-of-current-persp)))
      (setq cabbage-enlargement--curr-conf-history (cdr configs))
      (cabbage-enlargement--apply-winconfig (car configs)))))
