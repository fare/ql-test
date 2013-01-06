(cl:defpackage :ql-test
  (:use :cl :inferior-shell :xcvb-utils :lisp-invocation)
  (:export
   #:test-all-quicklisp-systems))
