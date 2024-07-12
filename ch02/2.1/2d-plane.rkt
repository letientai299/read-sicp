#lang racket

(require plot)

;-------------------------------------------------------------------------------
; Procedures to represent and use the "points" concept on a 2d plane,
; which has "x" and "y" coordinates.
;-------------------------------------------------------------------------------

(define (make-point x y)
  (cons x y))

(define (x-point a)
  (car a))

(define (y-point a)
  (cdr a))

(define (equal-point? a b)
  (and (= (x-point a) (x-point b))
       (= (y-point a) (y-point b))))

(define (println-point a)
  (printf "~a\n" (fmt-point a)))

(define (fmt-point a)
  (format "point(~a, ~a)" (x-point a) (y-point a)))

;-------------------------------------------------------------------------------
; Procedures to represent and use the "segments" concept on a 2d plane,
; which has a "start" and "end" points.
;-------------------------------------------------------------------------------
(define (make-segment a b)
  (cons a b))

(define (start-segment g)
  (car g))

(define (end-segment g)
  (cdr g))

(define (equal-segment? a b)
  (and (equal-point? (start-segment a) (start-segment b))
       (= (end-segment a) (end-segment b))))

(define (println-segment g)
  (printf "~a\n" (fmt-segment g)))

(define (fmt-segment g)
  (format "segment(~a, ~a)"
          (fmt-point (start-segment g))
          (fmt-point (end-segment g))))

(define (midpoint-segment g)
  (let ([a (start-segment g)] [b (end-segment g)])
    (make-point ;
     (/ (+ (x-point a) (x-point b)) 2)
     (/ (+ (y-point a) (y-point b)) 2))))

;-------------------------------------------------------------------------------
; Test for ex 2.2
;-------------------------------------------------------------------------------
(module+ test
  (require rackunit)
  (define a (make-point 1 2))
  (define b (make-point 3 6))

  (test-case "Mid point of 2 different point"
    (define g1 (make-segment a b))
    (define mid-g1 (midpoint-segment g1))
    (check-true (equal-point? mid-g1 (make-point 2 4))))

  (test-case "Mid point of segment from 1 point only"
    (define g2 (make-segment a a))
    (define mid-g2 (midpoint-segment g2))
    (check-true (equal-point? mid-g2 a)))

  (test-case "Order of x and y in make-point matters"
    (define a (make-point 1 2))
    (define b (make-point 2 1))
    (check-false (equal-point? a b)))

  (test-case "Order of start and end in make-segment matters"
    (define g1 (make-point a b))
    (define g2 (make-point b a))
    (check-false (equal-segment? g1 g2))))

;-------------------------------------------------------------------------------
; Ex 2.3
;-------------------------------------------------------------------------------

(define (make-rectangle a alpha w h)
  (let* ([x (x-point a)]
         [y (y-point a)]

         ; B
         [x_b (+ x (* w (cos alpha)))]
         [y_b (+ y (* w (sin alpha)))]
         [b (make-point x_b y_b)]

         ; D
         [x_d (+ x (* h (cos (+ (/ pi 2) alpha))))]
         [y_d (+ y (* h (sin (+ (/ pi 2) alpha))))]
         [d (make-point x_d y_d)]

         ; C
         [x_c (- (+ x_b x_d) x)]
         [y_c (- (+ y_b y_d) y)]
         [c (make-point x_c y_c)])
    ; Since at this point in the book, we haven't learn about `list` yet,
    ; our solution shouldn't use `list.` We only have `cons`.
    ;
    ; The data structure we use to represent the rectangle is basically
    ; an array of 4 points. That can be represented as
    ;
    ;   (cons a (cons b (cons c d)))))
    ;
    ; However, that will make our selectors harder to implement, as we have to
    ; handle the last 2 points differently. Instead we append a special nil
    ; element to indicate the end of array.
    (cons a (cons b (cons c (cons d 0))))))

;-------------------------------------------------------------------------------
; Drawing for ex 2.3
;-------------------------------------------------------------------------------

; return the 4 corners of the rectangle in their orders,
; stored as `list`, so that we can plot them.
(define (rectangle-points rect)
  (if (number? rect)
      (list)
      (let* ([a (car rect)]
             [p (list (x-point a) (y-point a))])
        (append (list p) (rectangle-points (cdr rect))))))

(define (plot-aspect n)
  (* 2/3 n))

(define draw-width 300)

(define (draw-rectangle)
  (parameterize ([plot-x-axis? #f]
                 [plot-y-axis? #f]
                 [plot-x-far-axis? #f]
                 [plot-y-far-axis? #f]
                 [plot-x-label #f]
                 [plot-y-label #f]
                 [plot-width draw-width]
                 [plot-height (plot-aspect draw-width)])
    (define x-min -2)
    (define y-min 0)
    (define x-max 7)
    (define y-max (+ (plot-aspect (- x-max x-min)) y-min))

    (define rect
      (make-rectangle (make-point 1 1) ; origin
                      (/ pi 5) ; alpha
                      3 ; width
                      2)) ; height

    (define ps (rectangle-points rect))
    (define A (list-ref ps 0))
    (define rect-sides (append ps (list (list-ref ps 0))))

    (plot-file ;
     (list ;
      (hrule (list-ref A 1) #:color 2 #:style 'short-dash)
      (lines rect-sides)
      ; this is `zip` in racket: https://stackoverflow.com/a/64041141
      (apply map
             point-label
             (list ps (list "A" "B" "C" "D"))))
     #:x-min x-min
     #:y-min y-min
     #:x-max x-max
     #:y-max y-max
     "2.3.rectangle.svg")))

(draw-rectangle)

(define (draw-rectangles-with-different-angles)
  (parameterize ([plot-x-axis? #f]
                 [plot-y-axis? #f]
                 [plot-x-far-axis? #f]
                 [plot-y-far-axis? #f]
                 [plot-width draw-width]
                 [plot-height (plot-aspect draw-width)])
    (define x-min -2)
    (define y-min -1)
    (define x-max 7)
    (define y-max (+ (plot-aspect (- x-max x-min)) y-min))

    (define A (make-point 2 1))
    (define w 3)
    (define h 2)

    (define rotations
      (map (lambda (i)
             (let* ([alpha (* i (/ pi 9))]
                    [rect (make-rectangle A alpha w h)]
                    [ps (rectangle-points rect)])
               (lines (append ps (list (list-ref ps 0))))))
           (inclusive-range -1 2)))

    (plot-file
     (append (list (point-label (vector (x-point A)
                                        (y-point A))
                                ""))
             rotations)
     #:x-min x-min
     #:y-min y-min
     #:x-max x-max
     #:y-max y-max
     "2.3.multi-rorations.svg")))

(draw-rectangles-with-different-angles)
