(cl:defpackage :ql-test
  (:use :cl :inferior-shell :asdf/driver :fare-utils :lisp-invocation)
  (:export
   #:test-all-quicklisp-systems))
