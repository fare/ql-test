(in-package :ql-test)

(defparameter *ql-test-directory* (subpathname *temporary-directory* "ql-test/"))

(defun test-system-command (system
                            &key (implementation-type *lisp-implementation-type*))
  (lisp-invocation-arglist
   :implementation-type implementation-type
   :eval (with-standard-io-syntax
           (let ((*print-case* :downcase)
                 (*package* (find-package :cl)))
             (format nil "'(#.~S#.~S#.~A)"
                     `(load ,(asdf:system-relative-pathname :ql-test "slave-init.lisp"))
                     `(asdf::ql-test-system ,(asdf:coerce-name system))
                     (quit-form :code 0))))))

(defun test-system (system &key (implementation-type *lisp-implementation-type*))
  (let ((output (subpathname *ql-test-directory* (strcat (asdf:coerce-name system) ".log"))))
    (ensure-directories-exist output)
    (run
     `((> ,output) (>& 2 1) (<& -)
       ,@(test-system-command system :implementation-type implementation-type)))))

(defun quicklisp-provided-sytems ()
  (ql-dist:provided-systems (ql-dist:dist "quicklisp")))

(defun test-all-quicklisp-systems ()
  (loop :for s :in (quicklisp-provided-sytems)
        :for n = (ql-dist:name s)
        :do (test-system n)))
