#lang debug racket
(require "../utils/bench.rkt")

(define (square x)
  (* x x))

;------------------------------------------------------------------------------
; Code from the book in 1.2.6
;------------------------------------------------------------------------------

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond
    [(> (square test-divisor) n) n]
    [(divides? test-divisor n) test-divisor]
    [else (find-divisor n (+ test-divisor 1))]))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (expmod base exp m)
  (cond
    [(= exp 0) 1]
    [(even? exp)
     (remainder (square (expmod base (/ exp 2) m)) m)]
    [else
     (remainder (* base (expmod base (- exp 1) m)) m)]))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond
    [(= times 0) true]
    [(fermat-test n) (fast-prime? n (- times 1))]
    [else false]))

;------------------------------------------------------------------------------
; Ex 1.27
;------------------------------------------------------------------------------
(module+ test
  (require rackunit)

  (define (fool-fermat-test carmichael-numbers)
    (for ([n carmichael-numbers])
      (test-case (format "~a" n)
        (for ([a (in-range 1 n)])
          (check-eqv? a (expmod a n n))))))

  (fool-fermat-test (list 561 1105 1729 2465 2821 6601)))

;------------------------------------------------------------------------------
; Ex 1.22
;------------------------------------------------------------------------------

(define tries 100)
(define count 1000)
(define (digits n)
  (if (>= 10 n) 1 (+ 1 (digits (/ n 10)))))

(define (search-for-primes start count)
  (define (iter n)
    (if (and (odd? n) (fast-prime? n tries))
        n
        (iter (+ n 1))))

  (if (= count 0)
      (list)
      (let ([p (iter start)])
        (cons p (search-for-primes (+ p 1) (- count 1))))))

(define some-primes
  (flatten (map (lambda (start) (search-for-primes start 5))
                '(1000 10000
                       100000
                       1000000
                       10000000
                       100000000
                       1000000000))))

(define (gen-stats)
  (printf "| Digits | Prime | `prime?` | `fast-prime?` |\n")
  (printf "| --- | --- | --- | --- | --- |\n")
  (for ([p some-primes])
    (define prime-time (bench count (lambda () (prime? p))))
    (define fast-prime-time
      (bench count (lambda () (fast-prime? p tries))))
    (printf "| ~a | ~a | ~a | ~a |\n"
            (digits p)
            p
            prime-time
            fast-prime-time)))

;------------------------------------------------------------------------------
; Ex 1.23
;------------------------------------------------------------------------------

(define (smallest-divisor-next n)
  (if (divides? 2 n) 2 (find-divisor-next n 3)))

(define (perf-diff-percentage from to)
  (round (* 100.0 (/ (- to from) from))))

(define (find-divisor-next n test-divisor)
  (cond
    [(> (square test-divisor) n) n]
    [(divides? test-divisor n) test-divisor]
    [else (find-divisor-next n (+ test-divisor 2))]))

(define (prime-next? n)
  (= n (smallest-divisor-next n)))

(define (compare-prime-and-prime-next)
  (printf
   "| Digits | Prime | `prime?` | `prime-next?` | Speed up |\n")
  (printf "| --- | --- | --- | --- | --- |\n")
  (for ([p some-primes])
    (define prime-time (bench count (lambda () (prime? p))))
    (define next-time
      (bench count (lambda () (prime-next? p))))
    (printf "| ~a | ~a | ~a | ~a | ~a% |\n"
            (digits p)
            p
            prime-time
            next-time
            (perf-diff-percentage prime-time next-time))))

; (compare-prime-and-prime-next)

;------------------------------------------------------------------------------
; Ex 1.25
;------------------------------------------------------------------------------

(require "./exponent.rkt")
(define (expmod-expt base exp m)
  (remainder (expt-fast base exp) m))

(define (compare-expmods)
  (printf "| Prime | `expmod` | `expmod-expt` | Diff |\n")
  (printf "| ---   | ---       | ---          | --- |\n")
  (for ([p (take some-primes 5)])
    (define base (- p 1))
    (define expmod-time
      (bench count (lambda () (expmod base p p))))
    (define expt-time
      (bench count (lambda () (expmod-expt base p p))))
    (printf "| ~a | ~a | ~a | ~a% |\n"
            p
            expmod-time
            expt-time
            (perf-diff-percentage expmod-time expt-time))))

; (compare-expmods)
