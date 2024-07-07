#lang racket

(require "./higher-order-procedures.rkt")
(require plot)

(define (smooth f dx)
  (lambda (x)
    (/ (+ ;
        (f (+ x dx))
        (f x)
        (f (- x dx)))
       3)))

(define (repeated-smooth f n dx)
  (define (smoother g)
    (smooth g dx))
  ((repeated smoother n) f))

(parameterize ([plot-width 600] [plot-height 400])
  (define x-min (* -3 pi))
  (define x-max (* 3 pi))
  (define scale 0.2)
  (define dx (* pi scale))
  (define f sin)

  (define (plot-func f index)
    (function f
              x-min
              x-max
              #:label (format "sin-smooth ~a" index)
              #:color index))

  (plot-file ;
   (append ;
    (list
     (function f x-min x-max #:label "sin" #:color "red"))
    (map (lambda (n) (plot-func (repeated-smooth f n dx) n))
         (range 1 10)))
   "1.44.svg"))
