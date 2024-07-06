#lang debug racket
(require "../utils/bench.rkt")

(provide prime?)
(provide fast-prime-miller-rabin?)

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
  (and (> n 1) (= n (smallest-divisor n))))

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
  (cond
    [(> 2 n) false]
    [(= 2 n) true]
    [else (try-it (+ 1 (random (- n 1))))]))

(define (fast-prime? n times)
  (cond
    [(= times 0) true]
    [(fermat-test n) (fast-prime? n (- times 1))]
    [else false]))

;------------------------------------------------------------------------------
; Ex 1.27
;------------------------------------------------------------------------------

; https://oeis.org/A002997
(define carmichael-numbers
  (list 561
        1105
        1729
        2465
        2821
        6601
        8911
        10585
        15841
        29341
        41041
        46657
        52633
        62745
        63973
        75361
        101101
        115921
        126217
        162401
        172081
        188461
        252601
        278545
        294409
        314821
        334153
        340561
        399001
        410041
        449065
        488881
        512461
        530881
        552721))

(module+ test
  (require rackunit)

  (define (fool-fermat-test)
    (for ([n carmichael-numbers])
      (test-case (format "~a" n)
        (for ([a (in-range 1 n)])
          (check-eqv? a (expmod a n n))))))

  (fool-fermat-test))

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

;------------------------------------------------------------------------------
; Ex 1.28
;------------------------------------------------------------------------------

(define (remove-power-of-2 n)
  (if (= 1 (remainder n 2)) n (remove-power-of-2 (/ n 2))))

; The Miller-Rabin test description in the book is wrong.
; See https://stackoverflow.com/a/59834347 and wikipedia.
; This procedure implement the definition on wikipedia.
(define (miller-rabin-test n)
  (define d (if (= n 1) 0 (remove-power-of-2 (- n 1))))

  (define (s-loop x d)
    (define y (remainder (square x) n))
    (cond
      [(> d n) x]
      [(and (= y 1) (> x 1) (< x (- n 1))) 0]
      [else (s-loop y (+ d d))]))

  (define (try-it a)
    ; x = a^d % n
    (define x (expmod a d n))
    (= (s-loop x d) 1))

  (cond
    [(> 2 n) false]
    [(= 2 n) true]
    [else (try-it (+ 2 (random (- n 2))))]))

(define (fast-prime-miller-rabin? n times)
  (cond
    [(= times 0) true]
    [(miller-rabin-test n)
     (fast-prime-miller-rabin? n (- times 1))]
    [else false]))

(define (show-bool b)
  (if b "yes <-" "no    "))

(define (show-result-for numbers title)
  (printf "\n~a\n"
          "----------------------------------------")
  (printf "~a\n" title)
  (printf "~a\n" "----------------------------------------")

  (define tries 10)
  (for ([n numbers])
    (define is-prime (prime? n))
    (define fermat (fast-prime? n tries))
    (define miller (fast-prime-miller-rabin? n tries))
    (printf
     "n=~a \t is-prime=~a \t fermat=~a \t miller-rabin=~a ~a ~a\n"
     n
     (show-bool is-prime)
     (show-bool fermat)
     (show-bool miller)
     (if (eq? fermat is-prime) "" " *** Fermat test fooled")
     (if (eq? miller is-prime) "" " !!! Miller test fooled"))))

; (show-result-for (range 1000 1050 2) "Some know composites")
; (show-result-for some-primes "Some know primes")
; (show-result-for (range 2 50 1) "Small")
; (show-result-for carmichael-numbers "Carmichael numbers")
