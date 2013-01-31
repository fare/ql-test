(in-package :asdf)

(defsystem :load-quicklisp
  :defsystem-depends-on (:asdf))

(block nil
  (flet ((try (x) (when (probe-file x) (return (load x)))))
    (try (subpathname (user-homedir-pathname) ".quicklisp/setup.lisp"))
    (try (subpathname (user-homedir-pathname) "quicklisp/setup.lisp"))
    (error "Couldn't find quicklisp in your home directory. Go get it at http://www.quicklisp.org/beta/index.html")))
