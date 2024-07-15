#lang racket

(define (rev vs)
  (define (iter res rem)
    (if (empty? rem)
        res
        (iter (cons (car rem) res) (cdr rem))))
  (iter null vs))

(define vs (range 0 5))
(printf "custom build:     ~a\n" (rev vs))
(printf "built-in reverse: ~a\n" (reverse vs))
