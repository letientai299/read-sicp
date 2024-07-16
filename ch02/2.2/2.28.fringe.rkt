#lang racket

(define (fringe tree)
  (define (walk node result)
    (cond
      [(null? node) result]
      [(not (pair? node)) (cons node result)]
      [else (walk (car node) (walk (cdr node) result))]))
  (walk tree null))

(define x (list (list 1 2) (list 3 4)))
(fringe x)
(flatten x)
(fringe (list x x))
(flatten (list x x))
