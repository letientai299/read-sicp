#lang racket

(define (same-parity first . rest)
  (define (iter vs)
    (if (null? vs)
        null
        (let ([head (car vs)] [tail (cdr vs)])
          (if (odd? (- first head))
              (iter tail)
              (cons head (iter tail))))))
  (cons first (iter rest)))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)
