#lang racket/base

; Goals: compute b^n in Θ(log n) time and Θ(n) space.
; Our function should take b and n as input
;   b: power
;   n: exponent
(define (fast-exponent b n)
  (define (square x) (* x x))
  ; We will use this internal function to compute b^n
  ;   acc: the current accumulation result
  ;   b: power
  ;   n: exponent
  (define (fast-exponent-iter acc b n)
    (cond ((= n 0) acc); terminate the iteration
          ; if n is even, then simplify the computation a half
          ((even? n) (fast-exponent-iter acc (square b) (/ n 2)))
          (else (fast-exponent-iter (* b acc) b (- n 1)))))
  (fast-exponent-iter 1 b n))

(fast-exponent 2 7); 128
(fast-exponent 2 16); 65536
(fast-exponent 3 3); 27
(fast-exponent 3 4); 81
(fast-exponent 3 41); 36472996377170786403
(fast-exponent 3 0); 1

