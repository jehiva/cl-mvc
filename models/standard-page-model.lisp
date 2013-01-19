(defpackage :standard-page-model
  (:use :common-lisp :mvc :standard-page)
  (:export :get-page-by-uri :get-pages))

(in-package :standard-page-model)

(defun get-page-by-uri (uri)
  "Search by uri - results returned: '(title content)"
  (first (clsql:query
   (format nil "SELECT `title`, `content` FROM `standard_page` WHERE `uri` = '~a'" uri))))

(defun get-pages ()
  (clsql:query
   (format nil "SELECT `uri`, `title`, `content` FROM `standard_page`")))
