(defsystem :ql-test
  :depends-on (:load-quicklisp
               :xcvb-utils :inferior-shell :lisp-invocation)
  :components
  ((:static-file "slave-init.lisp")
   (:file "package")
   (:file "ql-test" :depends-on ("package"))))
