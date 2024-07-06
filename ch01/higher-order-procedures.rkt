#lang debug racket

;------------------------------------------------------------------------------
; Code from the book
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

(printf "midpoint rule of cube: ~a\n"
        (integral cube 0 1 0.01))

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

(printf "simpson rule for cube: ~a\n"
        (simpson-integral cube 0 1 10))

;------------------------------------------------------------------------------
; Ex 1.31
;------------------------------------------------------------------------------

(define (product term a next b)
  (define (iter x res)
    (if (> x b) res (iter (next x) (* res (term x)))))
  (iter a 1))

(define (product-rec term a next b)
  (if (> a b)
      1
      (* (term a) (product term (next a) next b))))

(define (factorial-rec n)
  (product-rec identity 1 inc n))

(define (factorial n)
  (product identity 1 inc n))

(for ([n 11])
  (define rec (factorial-rec n))
  (define iter (factorial n))
  (printf "~a ~a! \t= ~a \n"
          (if (= iter rec) "ok" "!!!")
          n
          iter))

(define (wallis-product n)
  (define (wallis-term x)
    (define v (* 4.0 x x))
    (/ v (- v 1)))
  (* 2 (product wallis-term 1 inc n)))

; (for ([n (in-inclusive-range 1000 20000 1000)])
; (printf "|~a | ~a|\n" n (wallis-product n)))
