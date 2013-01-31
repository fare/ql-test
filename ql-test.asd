(defsystem :ql-test
  :defsystem-depends-on (:asdf)
  :depends-on (:load-quicklisp :fare-utils :alexandria :inferior-shell :lisp-invocation)
  :components
  ((:static-file "slave-init.lisp")
   (:file "package")
   (:file "ql-test" :depends-on ("package"))))
