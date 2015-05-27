(defsystem "ql-test"
  :version "0" ; not released
  :description "Trivial functions to help test Quicklisp"
  :author "Francois-Rene Rideau"
  :license "MIT"
  :depends-on ("load-quicklisp" "fare-utils" "alexandria" "inferior-shell" "lisp-invocation")
  :components
  ((:static-file "slave-init.lisp")
   (:file "package")
   (:file "ql-test" :depends-on ("package"))))
