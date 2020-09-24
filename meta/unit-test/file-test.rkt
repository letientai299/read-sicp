#lang racket/base

(require rackunit
         "file.rkt")

(check-equal? (my-+ 1 1) 2 "Simple addition")
(check-equal? (my-* 1 2) 2 "Simple multiplication")
