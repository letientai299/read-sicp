#lang racket

;-------------------------------------------------------------------------------
; Ex 2.30
;-------------------------------------------------------------------------------

(define (square-tree-hoc t)
  (map
   (lambda (node)
     (if (number? node) (sqr node) (square-tree-hoc node)))
   t))

(define (square-tree-direct t)
  (cond
    [(null? t) null]
    [(not (pair? t)) (sqr t)]
    [else
     (cons (square-tree-direct (car t))
           (square-tree-direct (cdr t)))]))

;-------------------------------------------------------------------------------
; Ex 2.30
;-------------------------------------------------------------------------------
(define (tree-map proc tree)
  (define (handle node)
    (if (pair? node) (tree-map proc node) (proc node)))
  (map handle tree))

(define (square-tree-by-tree-map t)
  (tree-map sqr t))

;-------------------------------------------------------------------------------
; Test code
;-------------------------------------------------------------------------------

(define t (list 1 (list 2 (list 3 4) 5) (list 6 7)))

(require "../../utils/debug.rkt")

(for ([method (list square-tree-hoc
                    square-tree-direct
                    square-tree-by-tree-map)])
  (show method (method t)))
