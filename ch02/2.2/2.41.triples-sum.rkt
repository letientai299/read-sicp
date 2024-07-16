#lang racket

(require "../../utils/debug.rkt")

; find all triples less than or equal n that sum to the target
(define (triples-sum n target)
  (filter (lambda (vs) (= target (apply + vs)))
          (unique-triples n)))

(define (unique-triples n)
  (define (triples-with k)
    (lambda (vs) (append vs (list k))))

  (define (triples k)
    (map (triples-with k) (unique-pairs (- k 1))))

  (foldr append null (map triples (inclusive-range 3 n))))

(define (unique-pairs n)
  (define (pair-with j)
    (lambda (i) (list i j)))
  (define (pairs j)
    (map (pair-with j) (inclusive-range 1 (- j 1))))
  (foldr append null (map pairs (inclusive-range 2 n))))

(define (flatmap proc vs)
  (flatten (map proc vs)))

(debug (flatmap range (inclusive-range 1 4)))
(debug (unique-pairs 5))
(debug (unique-triples 5))
(debug (triples-sum 5 8))
