#lang debug racket

(define (fact-iter n)
  (define (iter prod count)
    (if (> count n)
        prod
        (iter ;
         (* prod count)
         (+ count 1))))
  (iter 1 1))

(define (fact-recursive n)
  (if (>= 0 n) ;
      1
      (* n (fact-recursive (- n 1)))))

(module+ test
  (require rackunit)

  (define cases
    (list
     (cons 0 1)
     (cons 1 1)
     (cons 3 6)
     (cons 5 120)
     (cons 10 3628800)
     (cons 12 479001600)
     (cons 30 265252859812191058636308480000000)
     (cons 40
           815915283247897734345611269596115894272000000000)
     (cons
      52
      80658175170943878571660636856403766975289505440883277824000000000000)))

  (define (test-fn case)
    (define n (car case))
    (define want (cdr case))
    (test-case (format "iter: ~a -> ~a" n want)
      (check-eqv? want (fact-iter n)))
    (test-case (format "recursive:  ~a -> ~a" n want)
      (check-eqv? want (fact-recursive n))))

  (for-each test-fn cases))
