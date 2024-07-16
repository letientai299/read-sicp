#lang racket

(define (subsets s)
  (if (null? s)
      (list null)
      (let ([rest (subsets (cdr s))])
        (append rest
                (map (lambda (others) (cons (car s) others))
                     rest)))))

(define (subsets-iter set)
  (define (iter result vs head)
    (if (empty? vs)
        result
        (iter (cons (cons head (car vs)) result)
              (cdr vs)
              head)))

  (if (null? set)
      (list null)
      (let ([head (car set)]
            [kids (subsets-iter (cdr set))])
        (iter kids kids head))))

(define set (list 1 2 3))
(subsets set)
(subsets-iter set)
