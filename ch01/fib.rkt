#lang debug racket

(provide (all-defined-out))

(define (fib-rec n)
  (cond
    [(= n 0) 0]
    [(= n 1) 1]
    [else (+ (fib-rec (- n 1)) (fib-rec (- n 2)))]))

(define (fib-iter n)
  (define (iter a b i)
    (if (<= n i) a (iter b (+ a b) (+ i 1))))
  (iter 0 1 0))

(define phi (/ (+ 1 (sqrt 5)) 2))
(define psi (- 1 phi))
(define (fib-math n)
  (exact-round (/ (- (expt phi n) (expt psi n)) (sqrt 5))))

(define (fib-iter-fast n)
  (define (iter a b p q count)
    (cond
      [(= count 0) b]
      [(even? count)
       (iter a
             b
             (+ (sqr p) (sqr q)) ; p'
             (+ (sqr q) (* 2 p q)) ; q'
             (/ count 2))]
      [else
       (iter (+ (* b q) (* a q) (* a p))
             (+ (* b p) (* a q))
             p
             q
             (- count 1))]))
  (iter 1 0 0 1 n))

(module+ test
  (require rackunit)
  (for ([i 40])
    (define rec (fib-rec i))
    (define iter (fib-iter i))
    (define iter-fast (fib-iter-fast i))
    (define cal (fib-math i))
    (printf
     "~a \t recur=~a \t iter=~a \t iter-fast=~a \t math=~a\n"
     i
     rec
     iter
     iter-fast
     cal)
    (test-case (format "fib(~a)" i)
      (check-eqv? iter rec)
      (check-eqv? iter iter-fast)
      (check-eqv? iter cal))))
