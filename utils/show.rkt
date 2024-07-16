#lang racket

(provide show)
(provide debug)

(define-syntax debug
  (syntax-rules ()
    [(_ arg) (show "debug>" 'arg "=" arg)]
    [(_ arg more ...)
     (let ()
       (show "debug>" 'arg "=" arg)
       (debug more ...))]))

(define (show . vs)
  (for ([v vs])
    (display v)
    (display " "))
  (newline))
