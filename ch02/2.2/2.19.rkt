#lang racket

(define (count-change amount)
  (cc amount us-coins))

(define (cc amount coins)
  (cond
    [(= amount 0) 1]
    [(or (< amount 0) (no-more? coins)) 0]
    [else
     (+ (cc amount (except-first-denomination coins))
        (cc (- amount (first-denomination coins)) coins))]))

(define (no-more? coins)
  (empty? coins))

(define (except-first-denomination coins)
  (cdr coins))

(define (first-denomination coins)
  (car coins))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(cc 100 uk-coins)
(cc 100 us-coins)
