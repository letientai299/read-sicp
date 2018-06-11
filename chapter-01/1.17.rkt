#lang racket/base

(define (halve n) (quotient n 2))

(define (double x) (+ x x))

(define (even? x) (= (remainder x 2) 0))

(define (mult a n)
  (define (iter acc a n)
    (cond ((= n 0) acc)
          ((even? n) (iter acc (double a) (halve n)))
          (else (+ a (iter acc a (- n 1))))))

  (iter 0 a n))

(mult 2 3)
(mult 10 6)
(mult 10 7)
(mult 0 6)
(mult 1000 0)
