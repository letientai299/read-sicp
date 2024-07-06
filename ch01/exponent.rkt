#lang racket

(provide expt-fast)

; expt linear recursive provided by the book
; Time: O(n)
; Space O(n), note that this not tall-call.
(define (expt-rec b n)
  (if (= n 0) 1 (* b (expt-rec b (- n 1)))))

; expt linear iteratation, simplied using block structure style.
; Time: O(n)
; Space O(1)
(define (expt-iter b n)
  (define (iter prod cnt)
    (if (= n cnt) prod (iter (* prod b) (+ cnt 1))))
  (iter 1 0))

; expt faster using successive squaring.
; The implementation in the book is linear recursive.
; Below implementation is linear iteration.
;
; Time: O(log(n))
; Space O(1)
;
; Funny, I have implemented this precise algorithm in ./1.10.ackermann.rkt,
; in the function `power-of-2`, except that the input for `iter` is always 2.
(define (expt-fast b n)
  (define (square x)
    (* x x))
  (define (iter base rest more)
    (if (>= 1 rest)
        (* base more)
        (iter (square base)
              (quotient rest 2)
              (* more (if (odd? rest) base 1)))))
  (if (>= 0 n) 1 (iter b n 1)))

(module+ test
  (require rackunit)
  (for ([b 10])
    (for ([n 20])
      (define want (expt b n)) ; built-in
      (define rec (expt-rec b n))
      (define iter (expt-iter b n))
      (define fast (expt-fast b n))
      (test-case (format "expt(~a, ~a)" b n)
        (check-eqv? want rec)
        (check-eqv? want iter)
        (check-eqv? want fast)))))
