(defpackage :news
  (:use :common-lisp :mvc)
  (:export :controller))

(in-package :news)

(defun controller ()
  (standard-page:standard-page "News articles to come..."))
