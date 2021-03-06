#lang racket/base

(define (f n)
  (if (< n 3)
       n
       (+ (f (- n 1))
          (* 2 (f (- n 2)))
          (* 3 (f (- n 3))))))

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
