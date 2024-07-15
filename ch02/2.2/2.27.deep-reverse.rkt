#lang racket

(define (deep-reverse vs)
  (define (iter result remain)
    (if (empty? remain)
        result
        (let ([head (car remain)] ;
              [tail (cdr remain)])
          (iter ;
           (cons (deep-reverse head) result)
           tail))))
  (if (cons? vs) (iter null vs) vs))

(define x (list (list 1 2) (list 3 4)))
x
(reverse x)
(deep-reverse x)
