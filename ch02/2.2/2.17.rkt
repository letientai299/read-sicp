#lang racket

(define (last-pair vs)
  (if (null? (cdr vs))
      (list (car vs))
      (last-pair (cdr vs))))

(last-pair (list 1 2 3 4))
(last-pair (list 23 72 149 34))
