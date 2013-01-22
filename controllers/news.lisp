(defpackage :news
  (:use :common-lisp :mvc)
  (:export :controller))

(in-package :news)

;(mvc:mvc-loader "models/news-model")
;(mvc:mvc-loader "views/news-view")

(defun controller ()
  "This is the news controller"
  (let ((uri (hunchentoot:request-uri*)))
    (print uri)))


  
 ; (let* ((uri (hunchentoot:request-uri*))
	; (article (news-model:get-article-by-title uri)))
;    (if (equal 'CONS (type-of page)) (news-view:news page)
;	(news-view:news nil))))
