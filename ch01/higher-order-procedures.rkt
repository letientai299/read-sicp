#lang racket

;------------------------------------------------------------------------------
; Code from the book, section 1.3.1
;------------------------------------------------------------------------------

(define (itentity x)
  x)

(define (inc n)
  (+ n 1))

(define (cube x)
  (* x x x))

; original `sum` from the book, renamed to favor the iterative one below.
(define (sum-linear-recursion term a next b)
  (if (> a b) ;
      0
      (+ (term a) ;
         (sum term (next a) next b))))

; this is the better `sum` (iterative recursion, instead of the original linear
; recursion) resulted from Ex 1.30
(define (sum term a next b)
  (define (iter a result)
    (if (> a b) result (iter (next a) (+ result (term a)))))
  (iter a 0))

(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx))
  ; (* (sum f a add-dx b) dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))

; (printf "midpoint rule of cube: ~a\n"
; (integral cube 0 1 0.01))

;------------------------------------------------------------------------------
; Ex 1.29
;------------------------------------------------------------------------------

(define (simpson-integral f a b n)
  (define h (/ (- b a) n))

  (define (f-times k)
    (lambda (x) (* k (f x))))

  (define sum4
    (sum (f-times 4) (+ a h) (lambda (x) (+ x h)) (- b h)))

  (define sum2
    (sum (f-times 2)
         (+ a h h)
         (lambda (x) (+ x h h))
         (- b h h)))

  (* (/ h 3.0)
     (+ (f a) ; y_0
        (- sum4 sum2)
        (f b) ; y_n
        )))

; (printf "simpson rule for cube: ~a\n"
; (simpson-integral cube 0 1 10))

;------------------------------------------------------------------------------
; Ex 1.32
;------------------------------------------------------------------------------

(define (accumulate combine nil term a next b)
  (define (iter x res)
    (if (> x b)
        res ;
        (iter (next x) (combine res (term x)))))
  (iter a nil))

(define (accumulate-rec combine nil term a next b)
  (if (> a b)
      nil
      (combine
       (term a)
       (accumulate-rec combine nil term (next a) next b))))

;------------------------------------------------------------------------------
; Ex 1.31
;------------------------------------------------------------------------------

(define (product term a next b)
  (accumulate * 1 term a next b))
; (define (iter x res)
; (if (> x b) res (iter (next x) (* res (term x)))))
; (iter a 1))

(define (product-rec term a next b)
  (if (> a b)
      1
      (* (term a) (product term (next a) next b))))

(define (factorial-rec n)
  (product-rec identity 1 inc n))

(define (factorial n)
  (product identity 1 inc n))

; (for ([n 11])
; (define rec (factorial-rec n))
; (define iter (factorial n))
; (printf "~a ~a! \t= ~a \n"
; (if (= iter rec) "ok" "!!!")
; n
; iter))

(define (wallis-product n)
  (define (wallis-term x)
    (define v (* 4.0 x x))
    (/ v (- v 1)))
  (* 2 (product wallis-term 1 inc n)))

; (for ([n (in-inclusive-range 1000 20000 1000)])
; (printf "|~a | ~a|\n" n (wallis-product n)))

;------------------------------------------------------------------------------
; Ex 1.33
;------------------------------------------------------------------------------

(define (filtered-accumulate combine nil term a next b pick)
  (define (filtered x)
    (if (pick x) (term x) nil))
  (accumulate combine nil filtered a next b))

(require "./prime.rkt")

(define (sum-of-squared-primes a b)
  (define (square x)
    (* x x))
  (define (prime? n)
    (fast-prime-miller-rabin? n 10))
  (filtered-accumulate + 0 square a inc b prime?))

(define (product-of-smaller-coprimes n)
  (define (coprime? x)
    (= 1 (gcd x n)))
  (filtered-accumulate * 1 identity 1 inc (- n 1) coprime?))

; (product-of-smaller-coprimes 12) ; 1 5 7 11

;------------------------------------------------------------------------------
; Code based on section 1.3.3 in the book
;------------------------------------------------------------------------------

(define tolerante 0.00001)

(define (avg a b)
  (/ (+ a b) 2.0))

(define (close-enough? a b)
  (> tolerante (abs (- a b))))

; search for a root of `f` knowning a negative and a positive point.
(define (search f neg pos)
  (let ([mid (avg neg pos)])
    (if (close-enough? neg pos)
        mid
        (let ([v (f mid)])
          (cond
            [(zero? v) mid]
            [(negative? v) (search f mid pos)]
            [else (search f neg mid)])))))

(define (half-interval-method f a b)
  (let ([y1 (f a)] [y2 (f b)])
    (cond
      [(and (negative? y1) (positive? y2)) (search f a b)]
      [(and (positive? y1) (negative? y2)) (search f b a)]
      [else
       (error "Values are not of opposite sign" a b)])))

;; test the half-interval-method
;; f(x) = x^3 - 2x -3
; (define (f x)
; (- (cube x) (* 2 x) 3))
; (half-interval-method f 1 5)

; this implementation from the book will loop indefinitely
; if f(x) > x for any x >= guess.
(define (fixed-point f first-guess)
  (define (try guess)
    (let ([next (f guess)])
      (if (close-enough? guess next) next (try next))))
  (try first-guess))

(define (my-sqrt x)
  ; using average damping.
  (fixed-point (lambda (y) (avg y (/ x y))) 1.0))

;; computing golden ratio.
; (fixed-point (lambda (x) (+ 1 (/ 1 x))) 3.0)
