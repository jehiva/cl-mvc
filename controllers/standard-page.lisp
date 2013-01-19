(defpackage :standard-page
  (:use :common-lisp :mvc)
  (:export :controller :get-pages :standard-page))

(in-package :standard-page)

(mvc:mvc-loader "models/standard-page-model")
(mvc:mvc-loader "views/standard-page-view")

(defun controller ()
  (let* ((uri (hunchentoot:request-uri*))
	 (page (standard-page-model:get-page-by-uri uri)))
    (if (equal 'CONS (type-of page)) (standard-page-view:standard-page page)
	(standard-page-view:standard-page nil))))
