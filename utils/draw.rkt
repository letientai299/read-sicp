#lang racket

(provide (all-defined-out))

(require sdraw)
(require file/convertible)

(define (draw-box-pointer obj filename)
  (with-output-to-file
   filename
   #:exists 'truncate/replace
   (lambda ()
     (display ;
      (convert (sdraw obj #:null-style '/) 'svg-bytes)))))

(define (save-img pict name)
  (with-output-to-file ;
   name
   #:exists 'truncate/replace
   (lambda ()
     (display ;
      (convert pict 'png-bytes)))))
