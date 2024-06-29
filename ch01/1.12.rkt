#lang debug racket

(define (P r c)
  (if (or (= r 0) (= c 0) (= r c)) ;
      1
      (+ (P (- r 1) c) (P (- r 1) (- c 1)))))

;;;; TODO (tai): can we design an iter function for this, instead of tree-recur? ;;;;

(define (print-pascal-triangle n)
  (for ([r (in-inclusive-range 0 n)])
    (for ([c (in-inclusive-range 0 r)])
      (printf "~a\t" (P r c)))
    (newline)))

(print-pascal-triangle 10)
