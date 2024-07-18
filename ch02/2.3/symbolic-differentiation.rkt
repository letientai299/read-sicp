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
    [(or (=number? m1 0) (=number? m2 0)) 0]
    [(=number? m1 1) m2]
    [(=number? m2 1) m1]
    [else (list '* m1 m2)]))

(define (=number? e n)
  (and (number? e) (= e n)))

(define (make-exponentiation base power)
  (cond
    [(=number? base 0) (if (= power 0) 1 0)]
    [(=number? base 1) 1]
    [(=number? power 0) 1]
    [(=number? power 1) base]
    [else (list '^ base power)]))

(define (exponentiation? e)
  (and (pair? e) (eq? '^ (car e))))

(define (base e)
  (cadr e))

(define (power e)
  (caddr e))

(define (make-ln exp)
  (cond
    [(symbol? exp)
     ; if `exp` is a symbol, then return 1 if it's the constant `e`,
     ; otherwise, form the natural logarithm expression.
     (if (eq? exp 'e) 1 (list 'ln exp))]

    ; if `exp` is not a symbol, we check if it's a number and handle some
    ; special case.
    [(number? exp)
     (cond
       [(= 1) 0]
       [(> 0) (list 'ln exp)]
       [else
        (error "ln() is not defined for non positive number"
               exp)])]

    [else (error "unknown expression type: ln()" exp)]))

(define (ln? e)
  (and (pair? e) (eq? 'ln (car e))))

(define (arg e)
  (cadr e))

(define (division? e)
  (and (pair? e) (eq? '/ (car e))))
(define (dividend e)
  (cadr e))
(define (divisor e)
  (caddr e))

(define (make-division dividend divisor)
  (cond
    [(=number? divisor 0) (error "can't divide for zero")]
    [(=number? dividend 0) 0]
    [else (list '/ dividend divisor)]))

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

    [(division? exp)
     (let ([u (dividend exp)] [v (divisor exp)])
       (make-division
        (make-sum (make-product v (d u))
                  (make-product -1 (make-product u (d v))))
        (make-exponentiation v 2)))]

    [(ln? exp)
     (let ([u (arg exp)]) (make-division (d u) u))]

    [(exponentiation? exp)
     (let ([u (base exp)] ;
           [v (power exp)])
       (make-product exp (d (make-product v (make-ln u)))))]

    [else (error "unknown expression type: DERIV" exp)]))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

(debug (deriv '(+ x 3) 'x))
(debug (deriv '(* 2 (* x x)) 'x))
(debug (deriv '(* x y) 'x))
(debug (deriv '(* (* x y) (+ x 3)) 'x))

(debug (deriv '(ln (+ 2 x)) 'x))
(debug (deriv '(^ x 2) 'x))
(debug (deriv '(/ (^ x 2) (+ x 1)) 'x))

(deriv '(ln (+ 2 x)) 'x)
(deriv '(^ x 2) 'x)
(deriv '(/ (^ x 2) (+ x 1)) 'x)
