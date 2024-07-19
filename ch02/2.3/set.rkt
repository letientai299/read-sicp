#lang racket

(require "../../utils/debug.rkt")

(define (element-of-set? x set)
  (cond
    [(null? set) false]
    [(equal? x (car set)) true]
    [else (element-of-set? x (cdr set))]))

(define (adjoin-set x set)
  (if (element-of-set? x set) set (cons x set)))

(define (intersection-set a b)
  (if (or (null? a) (null? b))
      null
      (let ([x (car a)] [rest (cdr a)])
        (if (element-of-set? x b)
            (cons x (intersection-set rest b))
            (intersection-set rest b)))))

(define (union-set a b)
  (if (or (null? a) (null? b))
      b
      (let ([x (car a)] [rest (cdr a)])
        (if (element-of-set? x b)
            (union-set rest b)
            (cons x (union-set rest b))))))

(define a '(1 2 3))
(define b '(2 3 4))
(debug a
       b
       (intersection-set a b)
       (union-set a b)
       (adjoin-set 3 a))
