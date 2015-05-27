#-asdf3 (error "ASDF 3 or bust!")

(defsystem "load-quicklisp"
  :version "1.0.0"
  :description "load quicklisp"
  :author "Francois-Rene Rideau"
  :license "MIT")

(block nil
  (flet ((try (x) (when (probe-file x) (return (load x)))))
    (try (subpathname (user-homedir-pathname) ".quicklisp/setup.lisp"))
    (try (subpathname (user-homedir-pathname) "quicklisp/setup.lisp"))
    (error "Couldn't find quicklisp in your home directory. Go get it at http://www.quicklisp.org/beta/index.html")))
