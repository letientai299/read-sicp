#lang racket

;------------------------------------------------------------------------------
; Code provided by the book.
;------------------------------------------------------------------------------

(define (cube x)
  (* x x x))

(define (p x)
  (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))

;------------------------------------------------------------------------------
; Code to support the exercise
;------------------------------------------------------------------------------

(define (count-p-calls x)
  (define (iter x n)
    (if (not (> (abs x) 0.1)) n (iter (/ x 3.0) (+ n 1))))
  (iter x 0))
