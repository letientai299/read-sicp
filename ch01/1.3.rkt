#lang racket

(define (square x)
  (* x x))

(define (square-sum a b)
  (+ (square a) (square b)))

(define (smaller x a b)
  (and (< x a) (< x b)))

(define (top2-squared a b c)
  (cond
    [(smaller a b c) (square-sum b c)]
    [(smaller b c a) (square-sum c a)]
    [else (square-sum a b)]))

(top2-squared 1 2 2)

(module+ test
  (require rackunit)

  (struct args (a b c) #:transparent)
  (struct case (struct:args want) #:transparent)
  (define cases
    (list (case (args 0 1 1)
            2)
          (case (args 1 2 3)
            13)
          (case (args 3 4 2)
            25)))

  (for-each (lambda (c)
              (test-case (format "~V" c)
                         (define give (case-struct:args c))
                         (define got
                           (top2-squared (args-a give)
                                         (args-b give)
                                         (args-c give)))
                         (check-eq? got (case-want c))))
            cases))
