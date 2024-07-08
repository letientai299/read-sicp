#lang racket

(require "./higher-order-procedures.rkt")
(require plot)

(define (visualize-guesses-iterations N
                                      reversed-guesses
                                      filename-suffix)
  (parameterize ([plot-width 600]
                 [plot-height 400]
                 [plot-y-transform log-transform])
    (define (f x)
      (expt x x))

    (define x-max (argmax identity reversed-guesses))
    (define res (car reversed-guesses))

    (plot-file
     (list (hrule N #:label (format "y = ~a" N) #:color 1)
           (function f 2 x-max #:label "y = x^x" #:color 2)
           (point-label (vector res (f res)))
           (points (map vector
                        reversed-guesses
                        (map f reversed-guesses))
                   #:sym 'plus
                   #:label "guesses"
                   #:color 3))
     (format "1.36.guess-iterations.~a.svg"
             filename-suffix))))

;; computing root of x^x = 1000, thus x = log(1000)/log(x),
;; first guess is sqrt(log(1000))
(define N 1000)
(define (log-n-on-log-x N x)
  (/ (log N) (log x)))

(define (transformed x)
  (log-n-on-log-x N x))

(define first-guess (sqrt (log N)))

(define guesses
  (fixed-point-guesses transformed first-guess))

; (printf "without average damping: ~a\n" (length guesses))

(define damped-guesses
  (fixed-point-guesses (average-damp transformed)
                       first-guess))

; (printf "with average damping: ~a\n"
; (length damped-guesses))

; (define i 0)
; (for ([v (reverse damped-guesses)])
; (set! i (inc i))
; (printf "~a | ~a\n" i v))

; (visualize-guesses-iterations N
; damped-guesses
; "with-average-damping")

; (visualize-guesses-iterations N
; guesses
; "without-average-damping")

; (define initial 2)
; (for ([n (in-range 3 60)])
; (define N (exp n))
; (define (f x)
; (log-n-on-log-x N x))

; (define without (fixed-point-guesses f initial))
; (define with
; (fixed-point-guesses (average-damp f) initial))
; (printf "~a \t without=~a \t with=~a\n"
; n
; (length without)
; (length with)))

(define (visualize-guesses-counts)
  (parameterize ([plot-width 900]
                 [plot-height 600]
                 [plot-y-transform log-transform])
    (define xs (inclusive-range 3 400))

    (define (fn n)
      (lambda (x) (/ n (log x))))

    (define first-guess 6)
    (define (iter-count-without-avg-damp n)
      (length (fixed-point-guesses (fn n) first-guess)))

    (define (iter-count-with-avg-damp n)
      (length (fixed-point-guesses (average-damp (fn n))
                                   first-guess)))

    (plot-file
     (list
      (points (map vector
                   xs
                   (map (lambda (n)
                          (fixed-point (fn n) first-guess))
                        xs))
              #:label "fixed point"
              #:size 2
              #:color "black")
      (points
       (map vector xs (map iter-count-without-avg-damp xs))
       #:sym 'plus
       #:size 2
       #:label "without avg-damp"
       #:color "red")
      (points
       (map vector xs (map iter-count-with-avg-damp xs))
       #:label "with avg-damp"
       #:sym 'times
       #:size 2
       #:color "blue"))
     "1.36.iter-counts.svg")))

; (visualize-guesses-counts)

(define (approximate-x A n)
  (define (iter i acc l mul)
    (if (= n i)
        acc
        (iter ;
         (inc i)
         (+ acc (* mul (log l)))
         (log l)
         (* mul -1))))
  (/ A (iter 0 0 A 1)))

(define l (repeated log 2))
(define x0 2)
(for ([n (in-range 1 34)])
  (printf "log^~a(~a) = ~a\n" n x0 ((repeated log n) x0)))

(approximate-x (log 1000) 2)
(approximate-x (log 1000) 1)
