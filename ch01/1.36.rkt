#lang racket

(require "./higher-order-procedures.rkt")
(require plot)

;; computing root of x^x = 1000, thus x = log(1000)/log(x),
;; first guess is sqrt(log(1000))
(define (transformed x)
  (/ (log 1000) (log x)))

(define first-guess (sqrt (log 1000)))
(define reversed-guesses
  (fixed-point-guesses transformed first-guess))

(printf "without average damping: ~a\n"
        (length reversed-guesses))

(define damped-guesses
  (fixed-point-guesses (average-damp transformed)
                       first-guess))

(printf "with average damping: ~a\n"
        (length damped-guesses))

(parameterize ([plot-width 600]
               [plot-height 400]
               [plot-y-transform log-transform])
  (define (f x)
    (expt x x))

  (define x-max (argmax identity reversed-guesses))
  (define res (car reversed-guesses))

  (plot-file
   (list (hrule 1000 #:label "y = 1000" #:color 1)
         (function f 2 x-max #:label "y = x^x" #:color 2)
         (point-label (vector res (f res)))
         (points (map vector
                      reversed-guesses
                      (map f reversed-guesses))
                 #:sym 'plus
                 #:label "guesses"
                 #:color 3))
   "1.36.graph.svg"))

(define i 0)
(for ([v (reverse damped-guesses)])
  (set! i (inc i))
  (printf "~a | ~a\n" i v))
