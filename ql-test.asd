(defsystem "ql-test"
  :version "0" ; not released
  :description "Trivial functions to help test Quicklisp"
  :author "Francois-Rene Rideau"
  :license "MIT"
  :class package-inferred-system
  :depends-on ("ql-test/ql-test")
  :components
  ((:static-file "slave-init.lisp")))
