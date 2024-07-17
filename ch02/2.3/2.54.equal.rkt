#lang racket

(define (my-equal? a b)
  (let ([pair-a (pair? a)] [pair-b (pair? b)])
    (cond
      [(and pair-a pair-b)
       (and (my-equal? (car a) (car b))
            (my-equal? (cdr a) (cdr b)))]
      [(and (not pair-a) (not pair-b)) (eq? a b)]
      [else false])))

(module+ test
  (require rackunit)

  (define my-equal-cases
    (list (cons 1 2)
          (cons '(this is a word) '(this (is a) word))
          (cons '(a b c) '(a b x))
          (cons 'a 'a)))

  (for ([tc my-equal-cases])
    (let ([a (car tc)] [b (cdr tc)])
      (test-case (format "my-equal?: ~a vs ~a" a b)
        (check-equal? (my-equal? a b) (equal? a b))))))
