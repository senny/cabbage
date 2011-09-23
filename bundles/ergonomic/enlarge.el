
(defvar e-max-enlargement--window-configuration-store nil
  "Hash storing window configurations. persp-name -> list of configs.")

(defun e-max-enlargement--create-winconfig-store-if-nil ()
  (if (eq e-max-enlargement--window-configuration-store nil)
      (setq e-max-enlargement--window-configuration-store (make-hash-table :test 'equal :size 10))))

(defun e-max-enlargement--get-winconfigs-of-current-persp ()
  (e-max-enlargement--create-winconfig-store-if-nil)

  (let* ((persp (persp-new persp-curr))
         (configs (gethash e-max-enlargement--window-configuration-store)))
    configs))
