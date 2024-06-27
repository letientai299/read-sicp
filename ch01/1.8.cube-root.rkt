#lang debug racket

(define epsilon 1e-10)

(define (cube-root x)
  (cube-root-iter 1.0 x))

(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x) x)))

(define (improve guess x)
  (/ (+ (/ x (square guess)) (* 2 guess)) 3))

(define (good-enough? guess x)
  (>= epsilon (abs (- x (cube guess)))))

(define (cube x)
  (* x (square x)))

(define (square x)
  (* x x))

(define (abs x)
  (if (> 0 x) (- x) x))

; -----------------------------------------------------------------------------
; TEST
; -----------------------------------------------------------------------------
(module+ test
  (require rackunit)

  (for ([x (in-range 0 100 1/3)])
    (define y (sqrt x))
    (define diff (- x (square y)))
    (check-true (<= (abs diff) epsilon))))

; -----------------------------------------------------------------------------
; TRY
; -----------------------------------------------------------------------------
(for ([x (in-range 0 30)])
  (define y (cube-root x))
  (define diff (- x (cube y)))
  (printf "cube-root(~a) = ~a, diff=~a\n"
          x
          (exact->inexact y)
          (exact->inexact (abs diff))))
