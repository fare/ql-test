(cl:defpackage :ql-test
  (:use :cl :inferior-shell :asdf/driver :fare-utils :lisp-invocation)
  (:export
   #:install-all-quicklisp-provided-systems
   #:test-all-quicklisp-systems))
