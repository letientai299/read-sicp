#lang debug racket

(define (fib-rec n)
  (cond
    [(= n 0) 0]
    [(= n 1) 1]
    [else (+ (fib-rec (- n 1)) (fib-rec (- n 2)))]))

(define (fib-iter n)
  (define (iter a b i)
    (if (<= n i) a (iter b (+ a b) (+ i 1))))
  (iter 0 1 0))

;;;; TODO (tai): solve this ;;;;
(define (fib-math n)
  0)

(for ([i 10])
  (printf "~a \t recur=~a \t iter=~a \t math=~a\n"
          i
          (fib-rec i)
          (fib-iter i)
          (fib-math i)))
