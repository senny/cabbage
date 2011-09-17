(setq e-max-repository (expand-file-name "E-MAX-DIR/"))

(setq e-max-bundles '(
                      ergonomic
                      lisp
                      accessibility
                      ))

(load (concat e-max-repository "e-max"))
