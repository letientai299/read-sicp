#lang debug racket

;------------------------------------------------------------------------------
; Code from the book
;------------------------------------------------------------------------------

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

(integral cube 0 1 0.01)

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

(simpson-integral cube 0 1 10)
