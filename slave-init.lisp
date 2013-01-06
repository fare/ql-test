;;;;; ql-test slave-init -*- Mode: Lisp ; coding: utf-8 -*-

;;; 1- Load ASDF, be in its package, upgrade it
(in-package :cl-user)
(require :asdf)
(in-package :asdf)
(upgrade-asdf)

;;; 2- Load Quicklisp
(block nil
  (flet ((try (x) (when (probe-file x) (return (load x)))))
    (try (subpathname (user-homedir) ".quicklisp/setup.lisp"))
    (try (subpathname (user-homedir) "quicklisp/setup.lisp"))
    (error "Couldn't find quicklisp in your home directory. Go get it at http://www.quicklisp.org/beta/index.html")))

;;; 3- Configure away the normal ASDF source registry, so we only use Quicklisp.
(asdf:initialize-source-registry `(:source-registry :ignore-inherited-configuration))

;;; 4- Provide functionality for our caller.
(defun print-backtrace (out)
  "Print a backtrace (implementation-defined)"
  (declare (ignorable out))
  #+clozure (let ((*debug-io* out))
	      (ccl:print-call-history :count 100 :start-frame-number 1)
	      (finish-output out))
  #+sbcl
  (sb-debug:backtrace most-positive-fixnum out))

(defun call-with-ql-test-context (thunk)
  (block nil
    (handler-bind (((or error serious-condition)
                     (lambda (c)
                       (format *error-output* "~%~A~%" c)
                       (print-backtrace *error-output*)
                       (format *error-output* "~%~A~%" c)
                       (return nil))))
      (funcall thunk))))

(defmacro with-ql-test-context (() &body body)
  `(call-with-ql-test-context #'(lambda () ,@body)))

(defun ql-test-system (system)
  (with-ql-test-context ()
    (format t "~&TESTING SYSTEM ~A~%" system)
    (ql:quickload system :verbose t)
    (format t "~&SUCCESSFULLY LOADED SYSTEM ~A (I hope)~%" system)
    (asdf:test-system system :verbose t)
    (format t "~&SUCCESSFULLY TESTED SYSTEM ~A (I hope)~%" system)))
