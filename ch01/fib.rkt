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

(module+ test
  (require rackunit)
  (for ([i 40])
    (define rec (fib-rec i))
    (define iter (fib-iter i))
    (define cal (fib-math i))
    (printf "~a \t recur=~a \t iter=~a \t math=~a\n"
            i
            rec
            iter
            cal)
    (test-case (format "fib(~a)" i)
      (check-eqv? iter rec)
      (check-eqv? iter cal))))
