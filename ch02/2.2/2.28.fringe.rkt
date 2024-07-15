#lang racket

(define (append-logged . ls)
  (apply append ls))

(define (reverse-append a b)
  (if (null? b)
      a
      (reverse-append (cons (car b) a) (cdr b))))

(define x (list (list 1 2) (list 3 4)))

(define (fringe tree)
  (define (walk node result)
    (cond
      [(null? node) result]
      [(not (pair? node)) (cons node result)]
      [else (walk (car node) (walk (cdr node) result))]))
  (walk tree null))

(fringe x)
(flatten x)
(fringe (list x x))
(flatten (list x x))
