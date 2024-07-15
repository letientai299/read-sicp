#lang racket

;------------------------------------------------------------------------------
; Ex 2.21
;------------------------------------------------------------------------------

(define (square-list vs)
  (map sqr vs))

(define (square-list-manual vs)
  (if (null? vs)
      null
      (let ([x (car vs)] [rest (cdr vs)])
        (cons (sqr x) (square-list rest)))))

(define vs (inclusive-range 1 10))
(square-list vs)
(square-list-manual vs)
