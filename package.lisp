;; Load quicklisp
(load "~/quicklisp/setup.lisp")

;; load quicklisp files
(defmacro ql-loader (&rest packages)
  `(loop for pac in ,@packages do
	(progn
	  (ql:quickload pac))))

(ql-loader '(hunchentoot cl-who trivial-shell parenscript split-sequence clsql cl-ppcre))

;; define a package
(defpackage :mvc
  (:use :common-lisp :hunchentoot :cl-who :trivial-shell :split-sequence :clsql)
  (:export :parse-uri :mvc-loader +install-path+))
(in-package :mvc)

(defconstant +install-path+ "~/code/lisp/mvc")

;; start web server
(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))

;; start database connection
(clsql:connect '("localhost" "mvc_test" "mvc_user" "common-lisp") :database-type :mysql)

;; easily grab URI position
(defmacro parse-uri (position uri)
  "Position of URI element /first/second/third/fourth/..."
  `(,position (split-sequence:split-sequence #\/ ,uri
					     :remove-empty-subseqs t)))

(defmacro lower-case (word)
  `(format nil "~(~a~)" ,word))

(defmacro upper-case (word)
  `(format nil "~:@(~a~)" ,word))

(defmacro mvc-loader (package)
  `(progn
     (let* ((mvc-type (lower-case (parse-uri first ,package)))
	    (package-name (lower-case (parse-uri second ,package))))
       (load (format nil "~a/~a/~a.lisp" +install-path+ mvc-type package-name))
       (when (equal "controllers" mvc-type)
       (push (hunchentoot:create-regex-dispatcher
	      (format nil "^/~a/.*$" package-name)
	      (intern "CONTROLLER" (intern (upper-case package-name))))
	     hunchentoot:*dispatch-table*)
     (in-package :mvc)))))

(defun help-page ()
  (format nil "Help page"))

;; hunchentoot default dispatch table
(setq hunchentoot:*dispatch-table*
      (list
       (hunchentoot:create-regex-dispatcher "^/help.html$" 'help-page)))


;; loads a file and adds the dispatch macro
(mvc-loader "controllers/standard-page")
;; catch-all to send to standard page controller
(push (hunchentoot:create-regex-dispatcher "^/.*$" 'standard-page:controller) hunchentoot:*dispatch-table*)

(mvc-loader "controllers/news")

;; handle static assets for site
(push (hunchentoot:create-folder-dispatcher-and-handler "/assets/" (format nil "~a/assets/" +install-path+)) hunchentoot:*dispatch-table*)
