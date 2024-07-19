#lang racket

(provide debugln)
(provide debug)
(provide show)
(provide string-repeat)

(provide save-md)
(provide md-fence)
(provide md-text)

(define-syntax debugln
  (syntax-rules ()
    [(_ arg) (debug-show-ln arg)]
    [(_ arg more ...)
     (let ()
       (debug-show-ln arg)
       (debugln more ...))]))

(define-syntax-rule (debug-show-ln arg)
  (show ">\e[0;34m" 'arg "\e[0m\n" arg))

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

(define (string-repeat str n)
  (string-join (make-list n str) ""))

;-----------------------------------------------------------
; Support writing to markdown file
;-----------------------------------------------------------

(define md-text show)

(define-syntax-rule (md-fence lang body...)
  (let ()
    (printf "```~a\n" lang)
    body...
    (printf "\n```\n")))

(define-syntax save-md
  (syntax-rules ()
    [(_ file body ...)
     (begin
       (with-output-to-file file
                            #:exists 'truncate/replace
                            (lambda ()
                              body ...)))]))
