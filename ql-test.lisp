(in-package :ql-test)

(defparameter *ql-test-directory* (subpathname *temporary-directory* "ql-test/"))

(defun test-system-command (system
                            &key (implementation-type *implementation-type*))
  (lisp-invocation-arglist
   :implementation-type implementation-type
   :eval (with-standard-io-syntax
           (let ((*print-case* :downcase)
                 (*package* (find-package :cl)))
             (format nil "'(#.~S#.~S#.~A)"
                     `(load ,(asdf:system-relative-pathname :ql-test "slave-init.lisp"))
                     `(asdf::ql-test-system ,(asdf:coerce-name system))
                     (quit-form :code 0))))))

(defun test-system (system &key (implementation-type *implementation-type*))
  (let ((output (subpathname *ql-test-directory* (asdf:coerce-name system) :type "log")))
    (ensure-directories-exist output)
    (run
     `((> ,output) (>& 2 1) (< /dev/null)
       ,@(test-system-command system :implementation-type implementation-type))
     :on-error nil)))

(defun quicklisp-provided-sytems ()
  (ql-dist:provided-systems (ql-dist:dist "quicklisp")))

(defun quicklisp-provided-system-names ()
  (mapcar #'ql-dist:name (quicklisp-provided-sytems)))

(defun install-all-quicklisp-provided-systems ()
  (map () 'ql-dist:ensure-installed (quicklisp-provided-sytems)))

(defun test-all-quicklisp-systems (&key from)
  (let ((all-systems (quicklisp-provided-system-names)))
    (map () #'test-system
         (if from (member from all-systems :test 'equal) all-systems))))
