#lang racket

(define (make-interval a b)
  (cons a b))

(define (lower-bound it)
  (car it))

(define (upper-bound it)
  (cdr it))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ([p1 (* (lower-bound x) (lower-bound y))]
        [p2 (* (lower-bound x) (upper-bound y))]
        [p3 (* (upper-bound x) (lower-bound y))]
        [p4 (* (upper-bound x) (upper-bound y))])
    (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))))

(define (div-interval x y)
  (if (>= 0 (* (lower-bound y) (upper-bound y)))
      (error "divisor interval contains 0")
      (mul-interval x
                    (make-interval (/ 1 (upper-bound y))
                                   (/ 1 (lower-bound y))))))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (width it)
  (/ (- (upper-bound it) (lower-bound it)) 2))

(define (center it)
  (/ (+ (upper-bound it) (lower-bound it)) 2))

;------------------------------------------------------------------------------
; Ex 2.11
;------------------------------------------------------------------------------

(define (mul-interval-cryptic x y)
  (let ([x1 (lower-bound x)]
        [x2 (upper-bound x)]
        [y1 (lower-bound y)]
        [y2 (upper-bound y)]
        [-? negative?]
        [+? (lambda (x) (not (negative? x)))]
        [make make-interval])
    (cond
      [(and (+? x1) (+? x2) (+? y1) (+? y2))
       (make (* x1 y1) (* x2 y2))]
      [(and (+? x1) (+? x2) (-? y1) (+? y2))
       (make (* x2 y1) (* x2 y2))]
      [(and (-? x1) (+? x2) (+? y1) (+? y2))
       (make (* x1 y2) (* x2 y2))]

      [(and (-? x1) (-? x2) (+? y1) (+? y2))
       (make (* x1 y2) (* x2 y1))]
      [(and (+? x1) (+? x2) (-? y1) (-? y2))
       (make (* x2 y1) (* x1 y2))]
      [(and (-? x1) (+? x2) (-? y1) (-? y2))
       (make (* x2 y1) (* x1 y1))]

      [(and (-? x1) (-? x2) (-? y1) (+? y2))
       (make (* x1 y2) (* x1 y1))]
      [(and (-? x1) (-? x2) (-? y1) (-? y2))
       (make (* x2 y2) (* x1 y1))]

      ; 4 multiplications
      [(and (-? x1) (+? x2) (-? y1) (+? y2))
       (let ([p1 (* x1 y1)]
             [p2 (* x1 y2)]
             [p3 (* x2 y1)]
             [p4 (* x2 y2)])
         (make (min p1 p2 p3 p4) (max p1 p2 p3 p4)))])))

(module+ test
  (require rackunit)

  (define range-1 (inclusive-range -3 3))
  (for ([x1 range-1])
    (for ([x2 (in-inclusive-range (+ 1 x1) 2)])
      (for ([y1 range-1])
        (for ([y2 (in-inclusive-range (+ 1 y1) 2)])
          (define x (make-interval x1 x2))
          (define y (make-interval y1 y2))
          (define simple (mul-interval x y))
          (define cryptic (mul-interval-cryptic x y))

          (test-case (format "[~a,~a] * [~a,~a]"
                             x1
                             x2
                             y1
                             y2)
            (check-eqv? (lower-bound simple)
                        (lower-bound cryptic)
                        "lower-bound")
            (check-eqv? (upper-bound simple)
                        (upper-bound cryptic)
                        "upper-bound")))))))

;------------------------------------------------------------------------------
; Ex 2.12
;------------------------------------------------------------------------------

(define (make-center-percent c percent)
  (let ([w (* c percent)]) (make-center-width c w)))

(define (percent it)
  (/ (width it) (center it)))

(define (interval-eq? x y)
  (and
   (eqv? (* 1.0 (lower-bound x)) (* 1.0 (lower-bound y)))
   (eqv? (* 1.0 (upper-bound x)) (* 1.0 (upper-bound y)))))

(define (interval-fmt x)
  (format "[~a, ~a](width=~a, center=~a, percent=~a)"
          (lower-bound x)
          (upper-bound x)
          (width x)
          (center x)
          (percent x)))

(module+ test
  (require rackunit)
  (let ([a (make-interval 9 11)]
        [b (make-center-width 10 1)]
        [c (make-center-percent 10 0.1)])
    (test-case (format "~a vs width" (interval-fmt a))
      (check-true (interval-eq? a b) (interval-fmt b)))

    (test-case (format "~a vs percent" (interval-fmt a))
      (check-true (interval-eq? a c) (interval-fmt c)))))

;------------------------------------------------------------------------------
; Ex 2.13
;------------------------------------------------------------------------------
(define (mul-interval-tolerance x y)
  (let ([a (percent x)] [b (percent y)])
    (/ (+ a b) (+ 1 (* a b)))))

(module+ test
  (require rackunit)

  (let* ([a 1/10]
         ; using floating points here will cause precision error
         [b 2/10]
         [x (make-center-percent 10 a)]
         [y (make-center-percent 20 b)]
         [mul (mul-interval x y)])

    (check-eqv? (percent mul)
                (mul-interval-tolerance x y)
                (format "wanted: ~a" (percent mul)))))

;------------------------------------------------------------------------------
; Ex 2.14
;------------------------------------------------------------------------------

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2) (add-interval r1 r2)))

(define one (make-interval 1 1))

(define (par2 r1 r2)
  (div-interval one
                (add-interval (div-interval one r1)
                              (div-interval one r2))))

(define a 1)
(define b 3)
(define c 1)
(define d 5)
(define x (make-interval a b))
(define y (make-interval c d))
; (define x (make-center-width 100 1))
; (define y (make-center-width 200 1))
; (define x (make-center-percent 100 1/100))
; (define y (make-center-percent 200 1/200))

; (define z
; (make-interval (/ (* a c) (+ b d)) (/ (* b d) (+ a c))))

; z
"--"
(par1 x y)

"=="
; (define t
; (make-interval (/ (* a c) (+ a c)) (/ (* b d) (+ b d))))
; t
(par2 x y)
; (div-interval x x)
; (div-interval y y)

(define z (make-interval -1 2))
(mul-interval z (mul-interval z z))
