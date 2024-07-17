#lang racket
(require sicp-pict)
(require "../../utils/draw.rkt")
(require "../../utils/debug.rkt")

(define wave einstein)

(define (flipped-pairs painter)
  (let ([painter2 (beside painter (flip-vert painter))])
    (below painter2 painter2)))

(define (split first second)
  (define (loop p n)
    (if (= 0 n)
        p
        (let ([smaller (loop p (- n 1))])
          (first p (second smaller smaller)))))
  loop)

(define right-split (split beside below))
(define up-split (split below beside))

(define (corner-split painter n)
  (if (= 0 n)
      painter
      (let* ([corner (corner-split painter (- n 1))]
             [up (up-split painter (- n 1))]
             [right (right-split painter (- n 1))]
             [top-left (beside up up)]
             [bottom-right (below right right)])
        (beside (below painter top-left)
                (below bottom-right corner)))))

(define (square-limit p n)
  (let* ([quarter (corner-split p n)]
         [half (beside (flip-horiz quarter) quarter)])
    (below (flip-vert half) half)))

(define img (right-split wave 4))

;-----------------------------------------------------------
; Ex 2.46
;-----------------------------------------------------------
(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

(define (add-vect a b)
  (make-vect (+ (xcor-vect a) (xcor-vect b))
             (+ (ycor-vect a) (ycor-vect b))))

(define (sub-vect a b)
  (make-vect (- (xcor-vect a) (xcor-vect b))
             (- (ycor-vect a) (ycor-vect b))))

(define (scale-vect a s)
  (make-vect (* s (xcor-vect a)) (* s (ycor-vect a))))

;-----------------------------------------------------------
; Ex 2.47
;-----------------------------------------------------------
(define (make-frame-as-list origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame-as-list frame)
  (caddr frame))

(define (make-frame-as-cons origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (edge2-frame-as-cons frame)
  (cddr frame))

(define make-frame make-frame-as-list)
(define edge2-frame edge2-frame-as-list)

(when (odd? 2)
  (set! make-frame make-frame-as-cons)
  (set! edge2-frame edge2-frame-as-cons))

;-----------------------------------------------------------
; Ex 2.48
;-----------------------------------------------------------

(define (make-segment start end)
  (list start end))

(define (start-segment s)
  (car s))

(define (end-segment s)
  (cadr s))

;-----------------------------------------------------------
; Ex 2.49
;-----------------------------------------------------------

; convert from our custom vector defined above to sicp-pict types
(define (to-sicp-vect v)
  (vect (xcor-vect v) (ycor-vect v)))

; convert from our custom segment defined above to sicp-pict types
(define (to-sicp-segments ss)
  (map (lambda (s)
         (segment (to-sicp-vect (start-segment s))
                  (to-sicp-vect (end-segment s))))
       ss))

; helper method to convert from a path of points to sicp-segments
(define (points->segments . points)
  (let ([a (last points)] [b (first points)])
    (cons (segment a b) (apply path->segments points))))

(define (path->segments . points)
  (define (iter res pre remain)
    (if (empty? remain)
        res
        (let ([cur (car remain)])
          (iter (cons (segment pre cur) res)
                cur
                (cdr remain)))))
  (iter null (car points) (cdr points)))

; 1. draws the outline of the designated frame
(define outline
  (segments->painter ;
   (points->segments (vect 0 0)
                     (vect 0 1)
                     (vect 1 1)
                     (vect 1 0))))

; 2. draws an “X” by connecting opposite corners of the frame.
(define x-corners
  (segments->painter ;
   (list (segment (vect 0 1) (vect 1 0))
         (segment (vect 0 0) (vect 1 1)))))

; 3. draws a diamond shape by connecting the midpoints of the sides
(define diamond
  (segments->painter ;
   (points->segments (vect 0.5 0)
                     (vect 1 0.5)
                     (vect 0.5 1)
                     (vect 0 0.5))))

(define human
  (segments->painter ;
   (points->segments (vect 0.44 0.95)
                     (vect 0.37 0.9)
                     (vect 0.37 0.8)
                     (vect 0.44 0.76)
                     (vect 0.44 0.73)
                     (vect 0.35 0.7)
                     (vect 0.1875 0.6)
                     (vect 0 0.67)
                     (vect 0 0.6)
                     (vect 0.1875 0.5)
                     (vect 0.375 0.625)
                     (vect 0.25 0)
                     (vect 0.4 0)
                     (vect 0.5 0.35) ; low mid
                     (vect 0.6 0)
                     (vect 0.75 0)
                     (vect 0.625 0.625)
                     (vect 1 0.375)
                     (vect 1 0.45)
                     (vect 0.65 0.7)
                     (vect 0.56 0.73)
                     (vect 0.56 0.76)
                     (vect 0.63 0.8)
                     (vect 0.63 0.9)
                     (vect 0.56 0.95))))

;-----------------------------------------------------------
; Ex 2.50
;-----------------------------------------------------------

(define (my-flip-horiz p)
  (transform-painter p
                     (vect 1 0) ; new origin
                     (vect 0 0) ; new edge1
                     (vect 1 1))) ; new edge2

(define (my-flip-vert p)
  (transform-painter p
                     (vect 0 1) ; new origin
                     (vect 1 1) ; new edge1
                     (vect 0 0))) ; new edge2

(define (my-rotate180 p)
  (transform-painter p
                     (vect 1 1) ; new origin
                     (vect 0 1) ; new edge1
                     (vect 1 0))) ; new edge2

(define (my-rotate270 p)
  (transform-painter p
                     (vect 0 1) ; new origin
                     (vect 0 0) ; new edge1
                     (vect 1 1))) ; new edge2

;-----------------------------------------------------------
; Ex 2.51
;-----------------------------------------------------------
; `below` using direct tranformations
(define (my-below bot top)
  (let* ([center (vect 0 0.5)]
         [up (transform-painter top
                                center
                                (vect 1 0.5)
                                (vect 0 1))]
         [down (transform-painter bot
                                  (vect 0 0)
                                  (vect 1 0)
                                  center)])
    (lambda (frame)
      (up frame)
      (down frame))))

; `below` using `beside` with rotations
(define (my-below-rot bot top)
  (rotate90 (beside (rotate270 bot) (rotate270 top))))

;-----------------------------------------------------------
; Ex 2.52
;-----------------------------------------------------------

(define smile
  (segments->painter ;
   (append ;
    ; left eye
    (points->segments ;
     (vect 0.1 0.7)
     (vect 0.25 0.75)
     (vect 0.4 0.7))
    ; right eye
    (points->segments ;
     (vect 0.60 0.7)
     (vect 0.75 0.75)
     (vect 0.9 0.7))
    ; mouth
    (points->segments ;
     (vect 0.4 0.35)
     (vect 0.25 0.4)
     (vect 0.4 0.3)
     (vect 0.5 0.28)
     (vect 0.6 0.3)
     (vect 0.75 0.4)
     (vect 0.6 0.35)))))

(define smiley
  (let* ([len 0.25]
         [origin (vect 0.375 0.7)]
         [e1 (vect (+ len (vect-x origin)) (vect-y origin))]
         [e2 (vect (vect-x origin)
                   (+ len (vect-y origin)))])
    (lambda (frame)
      ((transform-painter smile origin e1 e2) frame)
      (human frame))))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

(define (draw obj)
  (define size 200)
  (paint obj #:width size #:height size))

; (save-img (draw smiley) "2.52.smiley.png")
