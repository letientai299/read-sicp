#lang racket/base

(define (fib-iter a b n)
  (if (= n 0) b (fib-iter (+ a b) a (- n 1))))

(define (fib n)
  (fib-iter 1 0 n))

(fib 0)
(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 6)
(fib 7)
(fib 8)
(fib 9)
(fib 10)
(fib 11)
(fib 12)
(fib 13)
(fib 14)
