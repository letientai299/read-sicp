#lang racket

(require "../../utils/debug.rkt")

;-----------------------------------------------------------
; Representing algebraic expressions
;-----------------------------------------------------------

(define (variable? e)
  (and (not (pair? e)) (not (number? e))))

(define (same-variable? v1 v2)
  (eq? v1 v2))

(define (sum? e)
  (and (pair? e) (eq? '+ (car e))))

(define (addend e)
  (cadr e))

(define (augend e)
  (caddr e))

(define (make-sum a1 a2)
  (cond
    [(and (number? a1) (= 0 a1)) a2]
    [(and (number? a2) (= 0 a2)) a1]
    [else (list '+ a1 a2)]))

(define (product? e)
  (and (pair? e) (eq? '* (car e))))

(define (multiplier e)
  (cadr e))

(define (multiplicand e)
  (caddr e))

(define (make-product m1 m2)
  (cond
    [(number? m1) (make-product m2 m1)]
    [(number? m2)
     (cond
       [(= 0 m2) 0]
       [(= 1 m2) m1])]
    [else (list '* m1 m2)]))

;-----------------------------------------------------------
; Compute re derivative of the given function
;-----------------------------------------------------------
(define (deriv exp var)
  (define (d e)
    (deriv e var))

  (cond
    [(number? exp) 0]

    [(variable? exp) (if (same-variable? var exp) 1 0)]

    [(sum? exp)
     (let ([a (addend exp)] ;
           [b (augend exp)])
       (make-sum (d a) (d b)))]

    [(product? exp)
     (let ([a (multiplier exp)] ;
           [b (multiplicand exp)])
       (make-sum (make-product a (d b))
                 (make-product b (d a))))]

    [else (error "unknown expression type: DERIV" exp)]))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

(debug (deriv '(+ x 3) 'x))
(debug (deriv '(* x y) 'x))
(debug (deriv '(* (* x y) (+ x 3)) 'x))
