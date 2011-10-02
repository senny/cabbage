(defvar e-max-plone-buildout--instance-argument-history nil)
(defvar e-max-plone-buildout--run-persp-prefix "*fg*")
(defvar e-max-plone-buildout--tests-persp-prefix "*tests*")


(defun e-max-plone-run (&optional known-names persp-prefix)
  "Searches for a known instance in the current buildout at starts it in pdb mode."
  (interactive)

  (catch 'exit
    (let ((cmd (e-max-plone-buildout--get-command known-names))
          (persp-prefix (or persp-prefix e-max-plone-buildout--run-persp-prefix)))
      (when (not cmd)
        (message "Could not find any buildout instance.")
        (throw 'exit nil))

      (let* ((script (car (split-string cmd)))
             (args (mapconcat 'identity (cdr (split-string cmd " ")) " ")))
        (setq args (read-string (concat script " ") args
                                'e-max-plone-buildout--instance-argument-history))

        (if (not e-max-plone-run-in-perspective)
            (pdb cmd)

          (let ((script-name (car (last (split-string script "/")))))
            (e-max-plone--run-pdb-in-persp cmd script-name persp-prefix)))))))

(defun e-max-plone-tests ()
  "Run tests in current buildout."
  (interactive)

  (e-max-plone-run e-max-plone-known-buildout-test-scripts
                   e-max-plone-buildout--tests-persp-prefix))


(defun e-max-plone--run-pdb-in-persp (cmd script-name persp-prefix)
  (let ((target-persp-name nil)
        (current-persp-name (persp-name persp-curr)))

    (if (eq (string-match persp-prefix current-persp-name) 0)
        (setq target-persp-name current-persp-name)

      (setq target-persp-name (concat persp-prefix current-persp-name "/" script-name))
      (e-max-persp target-persp-name))

    (let ((new-buffer-name (concat target-persp-name "*gud*")))
      (set-buffer (buffer-name (pdb cmd)))
      (ignore-errors (kill-buffer new-buffer-name))
      (rename-buffer new-buffer-name))))


(defun e-max-plone-buildout--get-command (&optional known-names)
  "Returns the command (absolute path and arguments) of the first found instance
script in this buildout"

  (let ((instances (or known-names e-max-plone-known-buildout-instances))
        (inst nil)
        (path nil)
        (buildout-root (e-max-plone--find-buildout-root default-directory)))
    (if buildout-root

        (catch 'loop
          (while instances
            (setq inst (car instances))
            (setq instances (cdr instances))
            (setq path (concat buildout-root (car inst)))

            (if (file-exists-p path)
                (if (car (cdr inst))
                    (throw 'loop (concat path " " (car (cdr inst))))
                  (throw 'loop path))))))))


(defun e-max-plone--pdb-hook ()
  (compilation-shell-minor-mode t)
  (gud-def gud-break  "break %d%f:%l"  "\C-b" "Set breakpoint at current line.")
  (gud-def gud-remove "clear %d%f:%l"  "\C-d" "Remove breakpoint at current line"))

(add-hook 'pdb-mode-hook 'e-max-plone--pdb-hook)
