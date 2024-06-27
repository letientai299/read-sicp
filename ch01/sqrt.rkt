#lang debug racket

(define epsilon 1e-5)

; sqrt implements the Newton's Square Root algorithm from the book.
; The different is the epsilon is externalized and much smaller.
(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (>= epsilon (abs (- x (square guess)))))

(define (square x)
  (* x x))

(define (abs x)
  (if (> 0 x) (- x) x))

; sqrt-v2 uses the new mechanism to check if guess is good enough,
; as described in exercise 1.7.
;
; Since good-enough-v2? can't handle 0 (infinite loop),
; this procedure explicitly returns 0 if the input is 0.
(define (sqrt-v2 x)
  (if (= x 0) 0 (sqrt-iter-v2 1 x)))

(define (sqrt-iter-v2 guess x)
  (define new-guess (improve guess x))
  (if (good-enough-v2? guess new-guess)
      guess
      (sqrt-iter-v2 new-guess x)))

(define (good-enough-v2? base other)
  (define diff (- base other))
  (>= (* base epsilon) (abs diff)))

(module+ test
  (require rackunit)

  (for ([x (in-range 0 100 1/3)])
    (define y (sqrt x))
    (define diff (- x (square y)))
    (check-true (<= (abs diff) epsilon))))

(println
 "sqrt ------------------------------------------------------------")
(for ([x (in-range 0 10)])
  (define y (sqrt x))
  (define diff (- x (square y)))
  (printf "sqrt(~a) = ~a, diff=~a\n"
          x
          (exact->inexact y)
          (exact->inexact (abs diff))))

(println
 "sqrt-v2 ---------------------------------------------------------")
(for ([x (in-range 0 10)])
  (define y (sqrt-v2 x))
  (define diff (- x (square y)))
  (printf "sqrt(~a) = ~a, diff=~a\n"
          x
          (exact->inexact y)
          (exact->inexact (abs diff))))
