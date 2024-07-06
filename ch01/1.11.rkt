#lang racket

(define (f-rec n)
  (if (< n 3)
      n
      (+ (f-rec (- n 1))
         (* 2 (f-rec (- n 2)))
         (* 3 (f-rec (- n 3))))))

(define (f-iter n)
  (define (iter i ; loop
                a ; f(n-1)
                b ; f(n-2)
                c) ; f(n-3)
    (cond
      [(= i 2) a]
      [(= i 1) b]
      [(= i 0) c]
      [else (iter (- i 1) (+ a (* 2 b) (* 3 c)) a b)]))
  (iter n 2 1 0))

(for ([n 20])
  (define rec (f-rec n))
  (define iter (f-iter n))
  (printf "~a: \t f-rec=~a \t f-iter=~a \t--> same=~a \n"
          n
          rec
          iter
          (eqv? rec iter)))
