#lang racket

(require "./higher-order-procedures.rkt")

(define (iterative-improve good-enough? improve-guess)
  (define (iter guess)
    (if (good-enough? guess)
        guess
        (iter (improve-guess guess))))
  iter)

(define (square-ii a)
  (define tolerante 0.0001)
  (define (good? x)
    (> tolerante (abs (- (* x x) a))))
  (define (improve x)
    (avg x (/ a x)))
  ((iterative-improve good? improve) 1))

(define (fixed-point-ii f guess)
  (define tolerante 0.0001)
  (define (good? x)
    (> tolerante (abs (- (f x) x))))
  (define improve f)
  ((iterative-improve good? improve) guess))

(sqrt 10)
(square-ii 10)
(fixed-point-ii (lambda (y) (avg y (/ 10 y))) 1.0)
(fixed-point-ii (lambda (x) (+ 1 (/ 1 x))) 3.0)
