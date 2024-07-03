#lang debug racket

(define (double a)
  (+ a a))

(define (halve a)
  (/ a 2))

(define (fast-mul a b)
  (cond
    [(= b 0) 0]
    [(even? b) (fast-mul (double a) (halve b))]
    [else (+ a (fast-mul a (- b 1)))]))

(module+ test
  (require rackunit)
  (for ([a 100])
    (for ([b 100])
      (define want (* a b))
      (define actual (fast-mul a b))
      (test-case (format "~a*~a" a b)
        (check-eqv? actual want)))))
