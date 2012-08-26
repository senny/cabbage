;; funs for looking up a definition, such as opening a imported module


(defun cabbage-plone-goto-defition (&optional)
  "Goes to the definition of the current word or line."
  (interactive)
  (if (search "import " (thing-at-point 'line))
      (cabbage-plone--deflookup-find-imported-module))
  (let ((symbol (current-word)))
    (if (not symbol)
        (error "Not at a import and not at a word."))
    (if (not (cabbage-plone--deflookup-goto-symbol symbol))
        (if (not (cabbage-plone--deflookup-goto-symbol (concat "class " symbol)))
            (progn (beginning-of-buffer)
                   (search-forward symbol))))))

(defun cabbage-plone-lookup-import (import)
  "Finds a file with its import path."
  (interactive "MPython import path: ")
  (if (not (search "import" import))
      (cabbage-plone--deflookup-find-imported-module (concat "import " import))
    (cabbage-plone--deflookup-find-imported-module import)))

(defun cabbage-plone--deflookup-buildout-find-omelette ()
  (let ((buildout-directory (cabbage-plone--find-buildout-root default-directory)))
    (let ((omelette-path (concat buildout-directory "parts/omelette/")))
      (if (file-exists-p omelette-path)
          omelette-path
        (error "Omelette not found")))))


(defun cabbage-plone--deflookup-open-file (path)
  "Opens a file, which may be symlinked (or any parent).
Follows the symlink if the target is within a /src directory."
  (let ((realpath (cabbage--expand-symlinks-recursively path)))
    (if (search "src" realpath)
        (find-file realpath)
      (find-file path))))


(defun cabbage-plone--deflookup-goto-symbol (symbol)
  "Go directly to a symbol, if it exists."
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols
            (symbol-list)
            (when (listp symbol-list)
              (dolist (symbol symbol-list)
                (let ((name nil) (position nil))
                  (cond
                   ((and (listp symbol) (imenu--subalist-p symbol))
                    (addsymbols symbol))
                   ((listp symbol)
                    (setq name (car symbol))
                    (setq position (cdr symbol)))

                   ((stringp symbol)
                    (setq name symbol)
                    (setq position (get-text-property 1 'org-imenu-marker symbol))))
                  (unless (or (null position) (null name))
                    (add-to-list 'symbol-names name)
                    (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist)
      (imenu (assoc symbol name-and-pos)))))


(defun cabbage-plone--deflookup-find-imported-module (&optional import)
  ;; find omelette
  (let* ((omelette (cabbage-plone--deflookup-buildout-find-omelette))
         (line (or import (thing-at-point 'line)))
         (path nil)
         (import nil))

    (if (not (search "import" line))
        (error "Could not find python import at current line."))

    ;; maybe the import line imports multiple thing seperated by ","
    (if (search "," line)
        (let* ((line (split-string line "import"))
               (symbol (cabbage-plone--deflookup-string-trim
                        (ido-completing-read "Symbol: "
                                             (split-string
                                              (replace-regexp-in-string
                                               "\n" ""
                                               (second line)) ",")))))
          (setq import (concat (first line) "import " symbol)))
      (setq import line))

    (setq path (replace-regexp-in-string
                "\\." "/"
                (replace-regexp-in-string
                 "^import " ""
                 (replace-regexp-in-string
                  " import " "."
                  (replace-regexp-in-string
                   "[ ]*from " ""
                   (replace-regexp-in-string
                    " as .*" ""
                    import))))))

    (if (not path)
        (error "Is the current line a python import?"))

    ;; strip new lines
    (setq path (replace-regexp-in-string "\n" "" path))

    ;; expect "from my.package import file""
    ;; open my/package/file.py
    (let ((expected-path (concat omelette path ".py"))
          (symbol nil))
      (if (file-exists-p expected-path)
          (cabbage-plone--deflookup-open-file expected-path)

        ;; expect "from my.package import folder"
        ;; open my/package/folder/__init__.py
        (setq expected-path (replace-regexp-in-string
                             "\\.py" "/__init__.py" expected-path))
        (if (file-exists-p expected-path)
            (cabbage-plone--deflookup-open-file expected-path)

          ;; expect "from my.package.folder import class"
          ;; open my/package/folder/__init__.py
          (setq symbol (let ((parts (split-string expected-path "/")))
                         (nth (- (length parts) 2) parts)))
          (setq expected-path (replace-regexp-in-string
                               "/[^/]*/__init__\\.py" "/__init__.py" expected-path))
          (if (file-exists-p expected-path)
              (progn
                (cabbage-plone--deflookup-open-file expected-path)
                ;; go to symbol
                (if (not (cabbage-plone--deflookup-goto-symbol symbol))
                    (if (not (cabbage-plone--deflookup-goto-symbol
                              (concat "class " symbol)))
                        (search-forward symbol))))

            ;; expect "from my.package.file import class"
            ;; open my/package/file.py
            (setq expected-path (replace-regexp-in-string
                                 "/__init__\\.py" ".py" expected-path))
            (if (file-exists-p expected-path)
                (progn
                  (cabbage-plone--deflookup-open-file expected-path)
                  ;; go to symbol
                  (if (not (cabbage-plone--deflookup-goto-symbol symbol))
                      (if (not (cabbage-plone--deflookup-goto-symbol
                                (concat "class " symbol)))
                          (search-forward symbol))))
              (message (concat "Not found: " expected-path)))))))))


;; helpers

(defun cabbage-plone--deflookup-string-ltrim (str)
  (let ((trim-pos (string-match "\\s +$" str)))
    (if trim-pos
        (substring str 0 trim-pos)
      str)))

(defun cabbage-plone--deflookup-string-rtrim (str)
  (let ((trim-pos (string-match "[^ \t]+" str)))
    (if trim-pos
        (substring str trim-pos)
      str)))

(defun cabbage-plone--deflookup-string-trim (str)
  (cabbage-plone--deflookup-string-rtrim (cabbage-plone--deflookup-string-ltrim str)))
