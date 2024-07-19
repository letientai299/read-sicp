#lang racket

(require "../../utils/debug.rkt")

;-----------------------------------------------------------
; Representing algebraic expressions
;-----------------------------------------------------------

(define (atomic? e)
  (or (number? e) (variable? e)))

(define (variable? e)
  (and (not (pair? e)) (not (number? e))))

(define (same-variable? v1 v2)
  (eq? v1 v2))

(define (sum? e)
  (and (pair? e) (eq? '+ (car e))))

(define (addend e)
  (cadr e))

(define (augend e)
  (let ([terms (cddr e)])
    (if (pair? (cdr terms)) (cons '+ terms) (car terms))))

(define (make-sum a1 a2)
  (cond
    [(and (number? a1) (number? a2)) (+ a1 a2)]
    [(=number? a1 0) a2]
    [(=number? a2 0) a1]
    [else (list '+ a1 a2)]))

(define (product? e)
  (and (pair? e) (eq? '* (car e))))

(define (multiplier e)
  (cadr e))

(define (multiplicand e)
  (let ([terms (cddr e)])
    (if (pair? (cdr terms)) (cons '* terms) (car terms))))

(define (make-product m1 m2)
  (cond
    [(or (=number? m1 0) (=number? m2 0)) 0]
    [(and (number? m1) (number? m2)) (* m1 m2)]
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
  (if (or (atomic? e) (not (exponentiation? e)))
      e
      (cadr e)))

(define (power e)
  (if (or (atomic? e) (not (exponentiation? e)))
      1
      (caddr e)))

(define (make-ln exp)
  (cond
    [(variable? exp)
     ; if `exp` is a symbol, then return 1 if it's the constant `e`,
     ; otherwise, form the natural logarithm expression.
     (if (eq? exp 'e) 1 (list 'ln exp))]

    [(pair? exp) (list 'ln exp)]

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
    [(=number? divisor 1) dividend]
    [else (list '/ dividend divisor)]))

(define (math-func? op)
  (case op
    [(ln) true]
    [else false]))

; extract the operator of the expressionk
(define (operator exp)
  (car exp))

; extract the operator of the expressionk
(define (terms exp)
  (cdr exp))

; return the priority of the expression
(define (priority op)
  (case op
    [(+) 1]
    [(* /) 10]
    [(math-func? op) 100]
    [(^) 1000]
    [else 0]))

(define (op-priority exp)
  (priority (if (atomic? exp) exp (operator exp))))

;-----------------------------------------------------------
; Simplify
;-----------------------------------------------------------
(define (simplify e)
  (if (atomic? e)
      e
      (let* ([op (operator e)]
             [vs (map simplify (terms e))])
        (cond
          [(eq? op '*) (simplify-mult vs)]
          [else (cons op vs)]))))

(define (simplify-mult vs)
  (let* ([a (car vs)]
         [bs (cdr vs)]
         [b (if (pair? bs) (car bs) bs)]
         [left (if (division? a) a b)]
         [right (if (division? a) b a)])
    (cond
      [(and (division? left) (division? right))
       (simplify
        (make-division
         (make-product (dividend left) (dividend right))
         (make-product (divisor left) (divisor right))))]
      [(division? left)
       (simplify (make-division
                  (make-product (dividend left) right)
                  (divisor left)))]
      [else (cons '* vs)])))

;-----------------------------------------------------------
; Compute derivative of the given function
;-----------------------------------------------------------
(define (deriv exp var)
  (define (d e)
    (deriv e var))

  (simplify
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
        (make-product exp
                      (d (make-product v (make-ln u)))))]

     [else (error "unknown expression type: DERIV" exp)])))

;-----------------------------------------------------------
; Format expression in Latex
;-----------------------------------------------------------
(define (fmt-latex exp)
  (define out display)

  (define (wrap left v right)
    (out left)
    (render v)
    (out right))

  (define spaced (lambda (x) (wrap " " x " ")))
  (define curly (lambda (x) (wrap "{" x "}")))
  (define paren (lambda (x) (wrap "\\left(" x "\\right)")))

  (define (maybe-wrapped outer inner)
    ; don't wrap in parens if the inner is:
    ; - simple atomic
    ; - a math function, which won't be confused
    ; - has less than or equal priority to the outer
    (if (or (atomic? inner)
            (math-func? (operator inner))
            (<= (op-priority outer) (op-priority inner)))
        (render inner)
        (paren inner)))

  (define (render e)
    (cond
      [(atomic? e) (out e)]

      [(sum? e)
       (maybe-wrapped e (addend e))
       (spaced '+)
       (maybe-wrapped e (augend e))]

      [(product? e)
       (let ([a (multiplier e)] [b (multiplicand e)])
         (maybe-wrapped e a)
         (when (and (number? a) (number? b))
           (spaced "\\cdot"))
         (maybe-wrapped e b))]

      [(exponentiation? e)
       (maybe-wrapped e (base e))
       (out '^)
       (curly (power e))]

      [(ln? e)
       (out "ln")
       (paren (arg e))]

      [(division? e)
       (out "\\frac")
       (curly (dividend e))
       (curly (divisor e))]

      [else (error "unknown expression type: FMT-LATEX" e)])

    ;
    )

  (with-output-to-string (lambda ()
                           (render (simplify exp)))))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

; (debug (deriv '(ln (+ 2 x)) 'x))
; (debug (deriv '(^ x 2) 'x))

(define (paragraph f)
  (newline)
  (if (procedure? f) (f) (display f))
  (newline))

(define (code-fenced x)
  (paragraph (lambda ()
               (display "```scheme")
               (newline)
               (display x)
               (newline)
               (display "```"))))

(define (math-fenced x)
  (paragraph (lambda ()
               (display "$$")
               (newline)
               (display x)
               (newline)
               (display "$$"))))

(with-output-to-file ;
 "temp.md"
 #:exists 'truncate/replace
 (lambda ()
   (define (visualize e)
     (paragraph "Expression")
     (code-fenced e)
     (math-fenced (fmt-latex e))

     (paragraph "Derivative")
     (define d (deriv e 'x))
     (code-fenced d)
     (math-fenced (format "\\frac{d}{dx} ~a = ~a"
                          (fmt-latex e)
                          (fmt-latex d)))
     (paragraph "---"))

   (visualize '(^ (+ x 1) (+ x 2)))
   (visualize '(/ (^ x 2) (+ x 1)))
   (math-fenced (fmt-latex '(* 2 (/ 1 x))))
   ; (visualize '(^ e (ln x)))
   ))
