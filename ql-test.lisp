(uiop:define-package :ql-test
  (:nicknames :ql-test/ql-test)
  (:use :cl :uiop :fare-utils
   :inferior-shell :lisp-invocation
   :optima :optima.ppcre)
  (:export
   #:current-quicklisp-asdf-version
   #:install-all-quicklisp-provided-systems
   #:test-all-quicklisp-systems
   #:clean-old-quicklisp-systems
   #:find-misnamed-secondary-asdf-systems-in-quicklisp
   #:quicklisp-software-directory
   #:qgrep
   #:systems-whose-name-doesnt-match-the-asd))
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

(defun bad-quicklisp-system-p (system) ;; for 2013121200
  (member (ql-dist:name system) '("XHTMLambda") :test 'equal))

(defun quicklisp-provided-systems ()
  (ql-dist:provided-systems (ql-dist:dist "quicklisp")))

(defun quicklisp-provided-system-names ()
  (mapcar #'ql-dist:name (quicklisp-provided-systems)))

(defun install-all-quicklisp-provided-systems ()
  (map () 'ql-dist:ensure-installed
       (remove-if 'bad-quicklisp-system-p (quicklisp-provided-systems))))

(defun test-all-quicklisp-systems (&key from)
  (let ((all-systems (quicklisp-provided-system-names)))
    (map () #'test-system
         (if from (member from all-systems :test 'equal) all-systems))))

(defun clean-old-quicklisp-systems ()
  (ql-dist::clean (ql-dist::dist "quicklisp")))

(defun current-quicklisp-asdf-version ()
  (match (run "wget -O - http://beta.quicklisp.org/quickstart/asdf.lisp"
              :output '(:line :at 1) :on-error 'continue)
    ((ppcre ";;; This is ASDF ([.0-9]+): Another System Definition Facility." version)
     version)))

(defun quicklisp-software-directory ()
  (subpathname (ql-dist:base-directory (ql-dist:find-dist "quicklisp")) "software/"))

(defun qgrep (arg &optional (output :lines))
  (run `(pipe (grep -ri ,arg) (grep -v "/asdf\\.lisp:"))
       :directory (quicklisp-software-directory)
       :output output))

(defun systems-whose-name-doesnt-match-the-asd ()
  (qgrep "defsystem "
         (lambda (s)
           (loop :for l = (read-line s nil nil) :while l :nconc
             (match (stripln l) ;; remove ^M from some lines
               ((ppcre "[^:]+/([^/:]+)[.]asd:[(]([-:a-z]*defsystem) ([:]name )*[#:\"]*([^[#:\"/ ]+)"
                       asdname _ _ sysname)
                (unless (equal asdname sysname)
                  (list (list asdname sysname))))
               ;;(_ (list (list :nomatch l)))
               )))))

(defun ql-dist-dir ()
  (subpathname (user-homedir-pathname) "quicklisp/dists/quicklisp/"))

(defun ql-projects-dir ()
  (subpathname (user-homedir-pathname) "src/common-lisp/quicklisp-projects/"))

(defun ql-source (x)
  (read-file-line (subpathname (ql-projects-dir) (strcat "projects/" x "/source.txt"))))


(defun find-misnamed-secondary-asdf-systems-in-quicklisp ()
  (let* ((all-asds (directory (merge-pathnames* #p"software/**/*.asd" (ql-dist-dir))))
         (defsystem-lines (run/lines `(grep "defsystem " ,@all-asds))))
    (dolist (line defsystem-lines)
      (match line
        ((ppcre "^([^:]+)/([^:]+).asd:.*\\([^ ]*defsystem +[#:\"]*([^ \"]+)(?:$|[ \"])"
                dir primary secondary)
         (unless (or (equal primary secondary) (string-prefix-p (strcat primary "/") secondary))
           (format t "Badly named system ~A in ~A/~A.asd~%"
                   secondary dir primary)))))))
