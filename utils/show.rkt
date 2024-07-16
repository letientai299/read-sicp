#lang racket

(provide show)

(define (show . vs)
  (for ([v vs])
    (display v)
    (display " "))
  (newline))
