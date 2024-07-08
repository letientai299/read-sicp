#lang racket

(provide (all-defined-out))

(require plot)
(require racket/trace)

(define log-call
  ((lambda (n)
     (lambda (name x)
       (set! n (+ n 1))
       (printf "~a \t| `~a` \t| `x=~a` \t|\n" n name x)))
   0))

;------------------------------------------------------------------------------
; Code from the book, section 1.3.1
;------------------------------------------------------------------------------

(define (identity x)
  x)

(define (inc n)
  (+ n 1))

(define (dec n)
  (- n 1))

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

; This implementation based on the book,
; modified to return the list of guess in reverse order,
; so that we can plot them, or collect them to report in some exercises.
; Note that will loop indefinitely if f(x) > x for any x >= guess.
(define (fixed-point f first-guess)
  (car (fixed-point-guesses f first-guess)))

(define (fixed-point-guesses f first-guess)
  (define (try guess)
    (let ([next (f guess)])
      (if (close-enough? guess next)
          (list next)
          (append (try next) (list guess)))))
  (try first-guess))

(define (my-sqrt x)
  ; using average damping.
  (fixed-point (lambda (y) (avg y (/ x y))) 1.0))

;------------------------------------------------------------------------------
; Ex 1.35
;------------------------------------------------------------------------------

;; computing golden ratio.
; (fixed-point (lambda (x) (+ 1 (/ 1 x))) 3.0)

;------------------------------------------------------------------------------
; Ex 1.37
;------------------------------------------------------------------------------

; this is very slow
(define (cont-frac-rec n d k)
  (define (recur i)
    (if (> i k) ;
        0.0
        (/ (n i) (+ 0.0 (d i) (recur (inc i))))))
  (recur 1))

(define (cont-frac n d k)
  (define (iter res k)
    (if (= 0 k) ;
        res
        (iter (/ ;
               (n k)
               (+ (d k) res))
              (dec k))))
  (iter 0.0 k))

(define (approximate-inverse-phi n)
  (approximate-inverse-phi-by cont-frac n))

(define (approximate-inverse-phi-by method n)
  (method (lambda (_) 1) (lambda (_) 1) n))

(require "./fib.rkt")

(define (try-cont-frac)
  (define method cont-frac)
  (for ([n 20])
    (define from-fib (/ (fib-math n) (fib-math (inc n))))
    (define frac (method (lambda (_) 1) (lambda (_) 1) n))
    (printf "~a -> ~a vs ~a \n"
            n
            frac
            (exact->inexact from-fib))))

; (for ([n 20])
; (printf "~a \t ~a\n" n (approximate-inverse-phi n)))

;------------------------------------------------------------------------------
; Ex 1.38
;------------------------------------------------------------------------------

(define (approximate-e n)
  (approximate-e-by cont-frac n))

(define (approximate-e-by method n)
  (define (d k)
    (if (< 0 (remainder (inc k) 3)) 1 (* 2 (/ (inc k) 3))))
  (+ 2 (method (lambda (_) 1) d n)))

(module+ test-skipped ; rename module to run test
  (require rackunit)
  (for ([n 20])
    (define e-iter (approximate-e-by cont-frac n))
    (define e-recur (approximate-e-by cont-frac-rec n))
    (test-case (format "e(~a)" n)
      (check-eqv? e-iter e-recur)))

  (for ([n 20])
    (define phi-iter
      (approximate-inverse-phi-by cont-frac n))
    (define phi-recur
      (approximate-inverse-phi-by cont-frac-rec n))
    (test-case (format "1/phi: ~a" n)
      (check-eqv? phi-iter phi-recur))))

;------------------------------------------------------------------------------
; Ex 1.39
;------------------------------------------------------------------------------

(define (tan-cf x k)
  (/ (cont-frac (lambda (_) (- (* x x)))
                (lambda (n) (dec (+ n n)))
                k)
     (- x)))

; (tan-cf 5 100)
; (tan 5)

;------------------------------------------------------------------------------
; Code from the book, section 1.3.4
;------------------------------------------------------------------------------

(define (average-damp f)
  (lambda (x) (avg x (f x))))

; deriv simulates derivative of a function g(x).
(define (deriv g)
  (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))
(define dx 0.000000001)

(define (newton-tranform g)
  (lambda (x) (- x (/ (g x) ((deriv g) x)))))

; Newton's method to find root of the g(x)
(define (newtons-method g guess)
  (fixed-point (newton-tranform g) guess))

; General idea of finding a root of g via transforming it into another function
; then use the fixed-point algorithm to estimate the root.
(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))

;------------------------------------------------------------------------------
; Ex 1.40
;------------------------------------------------------------------------------

; return a function that computes: x^3 + ax^2 + bx + c
(define (cubic a b c)
  (lambda (x)
    (+ ;
     (cube x)
     (* a (sqr x))
     (* b x)
     c)))

; (newtons-method (cubic 4 -3 -2) 1)
; (newtons-method (cubic 4 -3 -2) 0)
; (newtons-method (cubic 4 -3 -2) -10)

;------------------------------------------------------------------------------
; Ex 1.41
;------------------------------------------------------------------------------
(define (double f)
  (compose f f))

; (((double (double double)) inc) 5)
; ((double (double (double inc))) 5)

;------------------------------------------------------------------------------
; Ex 1.42
;------------------------------------------------------------------------------

(define (compose f g)
  (lambda (x) (f (g x))))

; ((compose sqr inc) 6)

;------------------------------------------------------------------------------
; Ex 1.43
;------------------------------------------------------------------------------

;; linear recursive, O(n)
(define (repeated-linear-rec f n)
  (if (= 0 n)
      identity
      (compose f (repeated-linear-rec f (- n 1)))))

; iter, O(n)
(define (repeated-iter f n)
  (define (iter g i)
    (if (= 0 i) g (iter (compose g f) (- i 1))))
  (iter identity n))

; successive squaring, O(log n)
(define (repeated-log-rec f n)
  (cond
    [(= n 0) identity]
    [(even? n) (repeated-log-rec (double f) (/ n 2))]
    [else (compose f (repeated-log-rec f (- n 1)))]))

; successive squaring + iterative
(define (repeated f n)
  (define (iter g more i)
    (cond
      [(>= 0 i) more]
      [(even? i) (iter (double g) more (/ i 2))]
      [else
       (iter (double g) (compose g more) (/ (- i 1) 2))]))
  (iter f identity n))

; (define rep repeated-log-rec)
; (define rep repeated)
; ((rep inc 10) 1)
