;; Finds components in the zope 3 component registry of the current instance
;; using collective.z3cinspector (http://github.com/collective/collective.z3cinspector)


(require 'url-http)
(cabbage-vendor 'json)


(defun cabbage-plone-find-adapter-by-name ()
  "Find an adapter by its name by searching the component registry of the current
zope instance. collective.z3cinspector needs to be installed on the zope instance."
  (interactive)
  (cabbage-plone--z3c-lookup "adapter_name"))

(defun cabbage-plone-find-adapter-by-providing-interface ()
  "Find an adapter by the interface it provides by searching the component
registry of the current zope instance. collective.z3cinspector needs to be
installed on the zope instance."
  (interactive)
  (cabbage-plone--z3c-lookup "adapter_provided_name"))

(defun cabbage-plone-find-utility-by-name ()
  "Find a utility by its name by searching the component registry of the current
zope instance. collective.z3cinspector needs to be installed on the zope instance."
  (interactive)
  (cabbage-plone--z3c-lookup "utility_name"))

(defun cabbage-plone-find-utility-by-providing-interface ()
  "Find a utility by the interface it provides by searching the component
registry of the current zope instance. collective.z3cinspector needs to be
installed on the zope instance."
  (interactive)
  (cabbage-plone--z3c-lookup "utility_provided_name"))



(defun cabbage-plone--z3c-lookup (type)
  "Search the component registry for adapters and utilities."
  (cabbage-plone--make-request
   (concat "@@inspector-ajax/" type "s")

   (lambda (status type)
     (let ((value (ido-completing-read
                   (concat type ": ")
                   (coerce (cabbage-plone--read-json-from-request) 'list))))

       (when value
         (cabbage-plone--make-request
          (concat "@@inspector-ajax/list_components?" type "=" value "&format=as_text")

          (lambda (status)
            (switch-to-buffer (current-buffer))
            (goto-char (point-min))
            (delete-region (point-min) (search-forward "\n\n"))
            (cabbage-plone--buttonize-buffer)
            (call-interactively 'beginning-of-buffer))))))

   (list type)))


(define-button-type 'cabbage-plone--find-file-button
  'follow-link t
  'action #'cabbage-plone--find-file-button)


(defun cabbage-plone--find-file-button (button)
  (let* ((location (buffer-substring (button-start button) (button-end button)))
         (path location)
         (line "0"))

    (when (string-match ":" location)
      (let ((parts (split-string location ":")))
        (setq path (car parts))
        (setq line (car (cdr parts)))))

    (find-file path)
    (goto-line (string-to-number line))))


(defun cabbage-plone--buttonize-buffer ()
  "turn all file paths into buttons"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "/[^ \t\r\n]*" nil t)
      (make-button (match-beginning 0) (match-end 0) :type
                   'cabbage-plone--find-file-button))))
