(cl:defpackage :ql-test
  (:use :cl :uiop :fare-utils
   :inferior-shell :lisp-invocation
   :optima :optima.ppcre)
  (:export
   #:current-quicklisp-asdf-version
   #:install-all-quicklisp-provided-systems
   #:test-all-quicklisp-systems
   #:clean-old-quicklisp-systems))
