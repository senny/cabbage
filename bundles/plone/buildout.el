(defvar e-max-plone-buildout--instance-argument-history nil)


(defun e-max-plone-run (&optional known-names)
  "Searches for a known instance in the current buildout at starts it in pdb mode."
  (interactive)

  (catch 'exit
    (let ((cmd (e-max-plone-buildout--get-command known-names)))
      (when (not cmd)
        (message "Could not find any buildout instance.")
        (throw 'exit nil))

      (let* ((script (car (split-string cmd)))
             (args (mapconcat 'identity (cdr (split-string cmd " ")) " ")))
        (setq args (read-string (concat script " ") args
                                'e-max-plone-buildout--instance-argument-history))

        (pdb cmd)))))

(defun e-max-plone-tests ()
  "Run tests in current buildout."
  (interactive)

  (e-max-plone-run e-max-plone-known-buildout-test-scripts))


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
