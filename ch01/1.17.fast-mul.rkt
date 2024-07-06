#lang racket

(define (double a)
  (+ a a))

(define (halve a)
  (/ a 2))

(define (fast-mul a b)
  (cond
    [(= b 0) 0]
    [(even? b) (fast-mul (double a) (halve b))]
    [else (+ a (fast-mul a (- b 1)))]))

(define (fast-mul-iter a b)
  (define (iter a b rest)
    (cond
      [(= b 0) rest]
      [(even? b) (iter (double a) (halve b) rest)]
      [else (iter a (- b 1) (+ a rest))]))

  (iter a b 0))

(module+ test
  (require rackunit)
  (for ([a 100])
    (for ([b 100])
      (define want (* a b))
      (define actual (fast-mul a b))
      (define actual-iter (fast-mul-iter a b))
      (test-case (format "~a*~a" a b)
        (check-eqv? want actual)
        (check-eqv? want actual-iter)))))
