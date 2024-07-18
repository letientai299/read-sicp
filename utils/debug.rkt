#lang racket

(provide debug)
(provide show)

(define-syntax debug
  (syntax-rules ()
    ; List of ansi color codes
    ; https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124
    [(_ arg) (debug-show arg)]
    [(_ arg more ...)
     (let ()
       (debug-show arg)
       (debug more ...))]))

(define-syntax-rule (debug-show arg)
  (show ">\e[0;34m" 'arg "\e[0m=" arg))

(define (show . vs)
  (for ([v vs])
    (display v)
    (display " "))
  (newline))
