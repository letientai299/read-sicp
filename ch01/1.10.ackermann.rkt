#lang debug racket

(define (A x y)
  (cond
    [(= y 0) 0]
    [(= x 0) (* 2 y)]
    [(= y 1) 2]
    [else (A (- x 1) (A x (- y 1)))]))

; define the h(n) function to test our custom implementation.
(define (h n)
  (A 2 n))

; A special https://en.wikipedia.org/wiki/Tetration function
; that returns 0 if n=0 instead of 1.
(define (tetration n)
  (cond
    [(>= 0 n) 0]
    [(= 1 n) 2]
    [else (power-of-2 (tetration (- n 1)))]))

; custom power of 2 in a tail-recursive manner,
; instead of using the built-in expt function, just for fun.
(define (power-of-2 n)
  (define (square x)
    (* x x))
  (define (iter base rest more)
    (if (>= 1 rest)
        (* base more)
        (iter (square base)
              (quotient rest 2)
              (* more (if (odd? rest) base 1)))))
  (if (>= 0 n) 1 (iter 2 n 1)))

(for ([i (in-inclusive-range 0 20)])
  (printf "~a -> ~a\n" i (power-of-2 i)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                                    TEST                                   ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(module+ test
  (require rackunit)
  ; can't test with n>=6 since the computation is too slow.
  (for ([n (in-inclusive-range 1 5)])
    (define result-h (h n))
    (define result-tetration (tetration n))
    (test-case (format "h(~a)" n)
      (check-eqv? result-h result-tetration))))
