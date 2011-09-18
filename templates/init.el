(setq e-max-repository (expand-file-name "E-MAX-DIR/"))

(setq e-max-bundles '(
                      accessibility
                      ergonomic
                      git
                      lisp
                      project
                      python
                      ))

(load (concat e-max-repository "e-max"))
