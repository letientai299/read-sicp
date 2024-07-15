#lang racket

(define (for-each-do proc vs)
  (let ([head (car vs)] [tail (cdr vs)])
    (proc head)
    (when (not (null? tail))
      (for-each-do proc tail))))

(define vs (inclusive-range 1 10))
(define (show-squared x)
  (printf "~a^2 = ~a\n" x (sqr x)))

(for-each show-squared vs)
"------------"
(for-each-do show-squared vs)
