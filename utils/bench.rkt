#lang slideshow
(provide bench)

; save a diagram to file
; (require plot)
; (plot-file (function sin (- pi) pi #:label "y = sin(x)")
; "board.svg")

; bench runs and capture the execution time of the the given `func` for
; `iterations` times, returns the average execution time in microseconds.
(define (bench iterations func)
  (define start (now))
  (for ([_ iterations])
    (func))
  (define elapsed (- (now) start))
  (define avg-ms (/ elapsed iterations))
  (* avg-ms 1000))

(define now current-inexact-monotonic-milliseconds)
