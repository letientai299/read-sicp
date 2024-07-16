#lang racket

(require "../../utils/debug.rkt")

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(module+ test
  (require rackunit)
  (printf "\nTest debug output\n\n"))

;-----------------------------------------------------------
; Ex 2.33.
;
; All function was prefixed with `my-` to avoid conflict
; with built-in functions.
;-----------------------------------------------------------

(define (my-map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) null sequence))

(define (my-append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (my-length sequence)
  (accumulate (lambda (_ res) (+ res 1)) 0 sequence))

(module+ test
  (require rackunit)

  (define x (inclusive-range 0 10))
  (debug (map sqr x))
  (debug (my-map sqr x))

  (define y (inclusive-range 100 110))
  (debug (append x y))
  (debug (my-append x y))

  (debug (length x))
  (debug (my-length x)))

;-----------------------------------------------------------
; Ex 2.34
;-----------------------------------------------------------

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms)
                (+ (* x higher-terms) this-coeff))
              0
              coefficient-sequence))

(module+ test
  (require rackunit)
  (debug (horner-eval 2 (list 1 3 0 5 0 1))))

;-----------------------------------------------------------
; Ex 2.35
;-----------------------------------------------------------
(define (count-leaves tree)
  (accumulate
   +
   0
   (map (lambda (node)
          (if (number? node) 1 (count-leaves node)))
        tree)))

(module+ test
  (require rackunit)
  (define tree (list 1 (list 2 (list 3 4)) 5))
  (debug (count-leaves tree)))

;-----------------------------------------------------------
; Ex 2.36
;-----------------------------------------------------------

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      null
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(module+ test
  (require rackunit)
  (test-case "accumulate-n"
    (define x (inclusive-range 1 5))
    (define y (reverse (inclusive-range 6 10)))
    (andmap (lambda (v) (check-eqv? 11 v))
            (accumulate-n + 0 (list x y)))))

;-----------------------------------------------------------
; Ex 2.37
;-----------------------------------------------------------

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(define (transpose mat)
  (accumulate-n cons null mat))

(define (matrix-*-matrix m n)
  (let ([cols (transpose n)])
    (map (lambda (row) (matrix-*-vector cols row)) m)))

(define vec (list 1 2 3 4))

(define mat
  (list (list 1 2 3 4) ;
        (list 4 5 6 6)
        (list 6 7 8 9)))

(module+ test
  (require rackunit)

  (debug (transpose mat))
  (debug (matrix-*-vector mat vec))
  (debug (matrix-*-matrix mat (transpose mat)))
  (debug (matrix-*-matrix (transpose mat) mat)))

;-----------------------------------------------------------
; Ex 2.38
;-----------------------------------------------------------
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (empty? rest)
        result
        ; note that the order of argument for `op`
        ; is not same with racket's `foldl`
        (iter (op result (car rest)) (cdr rest))))
  (iter initial sequence))

(define fold-right accumulate)

(module+ test
  (require rackunit)
  (test-case "fold left and right"
    (define x (inclusive-range 1 10))
    (define combine +)
    (define init 0)

    (define left (fold-left combine init x))
    (define left-want (foldl combine init x))
    (define right (fold-right combine init x))
    (define right-want (foldr combine init x))

    (debug left right)

    (check-equal? left left-want)
    (check-equal? right right-want))

  (debug (fold-right / 1 (list 1 2 3)))
  (debug (fold-left / 1 (list 1 2 3)))
  (debug (fold-right list null (list 1 2 3)))
  (debug (fold-left list null (list 1 2 3))))

;-----------------------------------------------------------
; Ex 2.39
;-----------------------------------------------------------

(define (reverse-fr sequence)
  (fold-right (lambda (x result) (append result (list x)))
              null
              sequence))

(define (reverse-fl sequence)
  (fold-left (lambda (result y) (cons y result))
             null
             sequence))

(module+ test
  (require rackunit)
  (test-case "reverse using fold left/right"
    (define x (inclusive-range 1 10))
    (define want (reverse x))
    (check-equal? (reverse-fr x) want "fold-right")
    (check-equal? (reverse-fl x) want "fold-left")))

;------------------------------------------------------------------------------
; Nested mappsings example: find i, j in [1,n] such that i+j is prime.
; https://sarabander.github.io/sicp/html/2_002e2.xhtml#Nested-Mappings
;------------------------------------------------------------------------------
(require "../../ch01/prime.rkt")

(struct pair (x y) #:transparent)

(define (unique-pairs n)
  (if (>= 0 n)
      null
      (let ([pre (- n 1)])
        (append (unique-pairs pre)
                (map (lambda (i) (pair n i))
                     (inclusive-range 1 pre))))))

(define (collect-prime-sum p res)
  (if (prime-sum? p) (cons p res) res))

(define (prime-sum? p)
  (prime? (+ (pair-x p) (pair-y p))))

(define (prime-sum-pairs n)
  (accumulate collect-prime-sum null (unique-pairs n)))

(debug (prime-sum-pairs 6))
