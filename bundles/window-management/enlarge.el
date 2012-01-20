(defvar e-max-enlargement--window-configuration-store nil
  "Hash storing window configurations. persp-name -> list of configs.")

(defvar e-max-enlargement--curr-conf-history nil
  "Temporary used list of configs when walking back the history.")

(defun e-max-enlargement--create-winconfig-store-if-nil ()
  (if (eq e-max-enlargement--window-configuration-store nil)
      (setq e-max-enlargement--window-configuration-store (make-hash-table :test 'equal :size 10))))

(defun e-max-enlargement--get-winconfigs-of-current-persp ()
  (e-max-enlargement--create-winconfig-store-if-nil)

  (let* ((persp (persp-name persp-curr))
         (configs (gethash persp e-max-enlargement--window-configuration-store)))
    (if (eq configs nil)
        '()
      configs)))

(defun e-max-enlargement--set-winconfigs-of-current-persp (configs)
  (e-max-enlargement--create-winconfig-store-if-nil)

  (let ((persp (persp-name persp-curr)))
    (puthash persp configs e-max-enlargement--window-configuration-store)))

(defun e-max-enlargement--get-current-winconfig ()
  (list (current-frame-configuration) (current-window-configuration)))

(defun e-max-enlargement--apply-winconfig (cfg)
  (set-frame-configuration (car cfg))
  (set-window-configuration (car (cdr cfg))))

(defun e-max-enlargement-enlarge ()
  (interactive)

  (unless (= (count-windows nil) 1)
    (unless (or (eq last-command 'e-max-enlargement-enlarge)
                (eq last-command 'e-max-enlargement-restore))
      (e-max-enlargement--set-winconfigs-of-current-persp
       (cons (e-max-enlargement--get-current-winconfig)
             (e-max-enlargement--get-winconfigs-of-current-persp))))
    (delete-other-windows)))

(defun e-max-enlargement-restore ()
  (interactive)

  (if (eq last-command 'e-max-enlargement-restore)
      (if (not e-max-enlargement--curr-conf-history)
          (message "Top reached: no more configurations to restore.")
        (e-max-enlargement--apply-winconfig (pop e-max-enlargement--curr-conf-history)))

    (let ((configs (e-max-enlargement--get-winconfigs-of-current-persp)))
      (setq e-max-enlargement--curr-conf-history (cdr configs))
      (e-max-enlargement--apply-winconfig (car configs)))))
