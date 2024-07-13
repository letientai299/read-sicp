#lang racket

(define zero ;
  (lambda (f) ;
    (lambda (x) x)))

(define (add-1 n)
  (lambda (f) ;
    (lambda (x) ;
      (f ((n f) x)))))

(define one ;
  (lambda (f) ;
    (lambda (x) ;
      (f x))))

(define two ;
  (lambda (f) ;
    (lambda (x) ;
      (f (f x)))))

(define (plus a b) ;
  (lambda (f) ;
    (lambda (x) ;
      ((a f) ((b f) x)))))

(define (mult a b) ;
  (lambda (f) ;
    (lambda (x) ;
      ((b (a f)) x))))

(define (square a) ;
  (lambda (f) ;
    (lambda (x) ;
      (((mult a a) f) x))))

(define (pow a b) ;
  (lambda (f) ;
    (lambda (x) ;
      (((b a) f) x))))

(define N (plus two two))

; for mapping from Church numerals to normal number system.
(define X 0)
(define (F x)
  (+ 1 x))

(define (pred n)
  (define (id x)
    ; (printf "id: ~a\n" x)
    x)

  ; (define cnt 0)

  (lambda (f)
    (define (swap g)
      (define (internal h)
        ; (set! cnt (+ 1 cnt))
        ; (printf "swap ~a: g=~a h=~a\n" cnt g h)
        (h (g f)))
      internal)

    (lambda (x)
      (define (const u)
        ; (printf "const: ~a\n" u)
        x)

      ; (((n swap) const) id)
      (define v1 (n swap))
      (define v2 (v1 const))
      (v2 id)

      ;
      )))

(define (to-number a)
  ((a F) X))

; (to-number (pred two))
(to-number (pred (mult (square two) (plus two two))))

(module+ test
  (require rackunit)

  (define (make a)
    (cond
      [(= 0 a) zero]
      [(= 1 a) one]
      [else (add-1 (make (- a 1)))]))

  ; small cap, because a^b is slow
  (define cap 5)

  (for ([a (in-range cap)])
    (define ca (make a))

    (test-case (format "basic: ~a" a)
      (check-eqv? a (to-number ca)))

    (for ([b (in-range cap)])

      (define cb (make b))

      (test-case (format "plus: ~a + ~a = ~a" a b (+ a b))
        (check-eqv? (+ a b) (to-number (plus ca cb))))

      (test-case (format "square: ~a^2 = ~a" a (* a a))
        (check-eqv? (* a a) (to-number (square ca))))

      (test-case (format "mult: ~a x ~a = ~a" a b (* a b))
        (check-eqv? (* a b) (to-number (mult ca cb))))

      (test-case (format "pow ~a^~a = ~a" a b (expt a b))
        (check-eqv? (expt a b) (to-number (pow ca cb))))

      ;
      )))
