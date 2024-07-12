#lang racket

(require "../../ch01/exponent.rkt")

(define (int-cons a b)
  (* (expt-fast 2 a) (expt-fast 3 b)))

(define (int-car p)
  (factor p 2))

(define (int-cdr p)
  (factor p 3))

(define (factor n a)
  (define (is-divisible? v)
    (= 0 (remainder v a)))

  (define (iter n v)
    (if (is-divisible? v) ;
        (iter (+ 1 n) (/ v a))
        n))

  (iter 0 n))

(define p (int-cons 4 100))
(int-car p)
(int-cdr p)
