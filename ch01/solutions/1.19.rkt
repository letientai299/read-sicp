#lang racket/base

; With help from paper and pen, we can find:
; p' = p^2 + q^2
; q' = 2pq + q^2

; We can complete faster version of fib-iter as below
(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q n)
  (cond ((= n 0) b)
        ((even? n)
         (fib-iter a
                   b
                   ; p'
                   (+ (* p p) (* q q))
                   ; q'
                   (+ (* 2 p q) (* q q))
                   (/ n 2)))
        (else
          (fib-iter (+ (* b q)
                       (* a q)
                       (* a p))
                    (+ (* b p)
                       (* a q))
                    p
                    q
                    (- n 1)))))
; This algorithm, and the observation is very nice. That's why I love math.

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
