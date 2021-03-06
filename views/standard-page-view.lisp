(defpackage :standard-page-view
  (:use :common-lisp :mvc :standard-page :cl-who :hunchentoot)
  (:export :get-menu :standard-page))

(in-package :standard-page-view)

(defmacro get-file-contents-as-string (stream)
  `(let ((lines (loop for line = (read-line ,stream nil 'eof)
       until (eq line 'eof)
       collect line)))
    (format nil "~{~a~%~}" lines)))

(defmacro do-regex (html var val)
  `(cl-ppcre:regex-replace-all (format nil "{~(~a~)}" ,var) ,html ,val))

(defun code-from-string-as-string (string)
  (format nil "~a" (eval (read-from-string string))))

(defun template-file-evals (html)
  (cl-ppcre:do-matches-as-strings (match "{eval=(.*?)}" html)
    (setf html (cl-ppcre:regex-replace "{eval=(.*?)}" html (code-from-string-as-string
				       (subseq match 6 (- (length match) 1))))))
  html)

(defun get-html-template (&optional template-file)
  (let ((file-name
	 (format nil "~a/templates/~a"
		 mvc:+install-path+
		 template-file)))
    (if (probe-file file-name)
      (with-open-file (tpl-in-stream file-name)
	(get-file-contents-as-string tpl-in-stream))
      (format nil "Error: Template file ~a is missing!~%" template-file))))

(defun template-file-includes (html)
  (cl-ppcre:do-matches-as-strings (match "{include=(.*?)}" html)
    (setf html (cl-ppcre:regex-replace "{include=(.*?)}" html (get-html-template
				       (subseq match 9 (- (length match) 1))))))
  html)

(defun fill-template-vars (symbols html)
  (let ((html (do-regex html
		(symbol-name (first symbols))
		(symbol-value (first symbols)))))
    (if (equal (type-of (rest symbols)) 'CONS)
	(fill-template-vars (rest symbols) html)
	html)))

(defun get-menu (pages)
  (let* ((page (first pages))
	 (pages (rest pages)))
    (format nil "<li><a href='~a'>~a</a></li>~%~a"
	    (first page)
	    (second page)
	    (if (not (equal 'CONS (type-of pages))) ""
		(get-menu pages)))))

(defun fill-template-vars (symbols html)
  (let ((html (do-regex html
		(symbol-name (first symbols))
		(symbol-value (first symbols)))))
    (if (equal (type-of (rest symbols)) 'CONS)
	(fill-template-vars (rest symbols) html)
	html)))

(defun get-menu (pages)
  (let* ((page (first pages))
	 (pages (rest pages)))
    (format nil "<li><a href='~a'>~a</a></li>~%~a"
	    (first page)
	    (second page)
	    (if (not (equal 'CONS (type-of pages))) ""
		(get-menu pages)))))

(defun standard-page (page)
  (let ((title (if page (first page) "404 not found"))
	(content (if page (second page) "page missing"))
	(template-html (template-file-includes (get-html-template "default.html")))
	(menu (get-menu (standard-page-model:get-pages))))
    ;; ugly workaround 
    (defparameter *title* title)
    (defparameter *content* content)
    (defparameter *menu* menu)
    (defparameter *uri* (hunchentoot:request-uri*))
    (setf template-html (template-file-evals template-html))
    (fill-template-vars
     '(*title* *content* *menu* *uri*)
     template-html)))
