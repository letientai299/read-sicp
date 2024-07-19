#lang racket

(require "../../utils/debug.rkt")

(define (in? x set)
  (cond
    [(null? set) false]
    [(equal? x (car set)) true]
    [(< x (car set)) false]
    [else (in? x (cdr set))]))

(define (intersect a b)
  (if (or (null? a) (null? b))
      null
      (let ([x (car a)] [y (car b)])
        (cond
          [(= x y) (cons x (intersect (cdr a) (cdr b)))]
          [(> x y) (intersect a (cdr b))]
          [else (intersect (cdr a) b)]))))

(define (union a b)
  (cond
    [(null? a) b]
    [(null? b) a]
    [else
     (let ([x (car a)] [y (car b)])
       (cond
         [(= x y) (cons x (union (cdr a) (cdr b)))]
         [(> x y) (cons y (union a (cdr b)))]
         [else (cons x (union (cdr a) b))]))]))

(define (adjoin x set)
  (let ([y (car set)])
    (cond
      [(= x y) set]
      [(> x y) (cons y (adjoin x (cdr set)))]
      [else (cons x set)])))

(define a '(1 2 5))
(define b '(2 3 4))
(debug a ;
       b
       (intersect a b)
       (union a b)
       (adjoin 3 a))
