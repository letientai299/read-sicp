#lang racket/base

; Define the iteractive function for calculate f(n)
; as the formula requires 3 previous values of f(), we will have to store 4
; values, include 3 previous values and the counter.
(define (f-iter x1 x2 x3 counter)
  ; the counter should be decreased until it is < 3
  (if (= counter 2)
    x3
    (f-iter x2
            x3
            (+ x3
               (* 2 x2)
               (* 3 x1))
            (- counter 1))))

(define (f n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        ((= n 2) 2)
        (else (f-iter 0 1 2 n))))



(f 0)
(f 1)
(f 2)
(f 3)
(f 4)
(f 5)
(f 6)
(f 7)
(f 8)
(f 9)
(f 10)
(f 11)


; f(0) = 0
; f(1) = 1
; f(2) = 2
; f(3) = 4
; f(4) = 11
; f(5) = 25
; f(6) = 59
; f(7) = 142
; f(8) = 335
; f(9) = 796
; f(10) = 1892
; f(11) = 4489
