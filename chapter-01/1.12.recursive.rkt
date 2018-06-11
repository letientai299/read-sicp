#lang racket/base

; Sample:
; 1
; 1 1 
; 1 2 1
; 1 3 3 1
; The value is in 2d space, thus, we will need 2 indexes to refer to a value. 
; We can define a function f(x, y), such that x is a non negative integer, and 
; y in a non negative integer that lesser than or equal to x+1.
; So: 
; - f(x, y) = 1 if y = 0 or y = x+1 (the edges)
; - f(x, y) = f(x-1, y) + f(x-1, y-1) 

(define (f x y)
  (cond ((= y 0) 1)
        ((= y x) 1)
        (else (+ (f (- x 1) y) (f (- x 1) (- y 1))))))

; Try it:
(f 0 0) ; 1
(f 1 0) ; 1 
(f 1 1) ; 1
(f 3 1) ; 3
(f 4 2) ; 6
(f 10 5) ; 252
(f 14 7) ; 3432

