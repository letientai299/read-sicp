#lang racket

;------------------------------------------------------------------------------
; Other code that won't be affected from changing from `list` to `cons`
;------------------------------------------------------------------------------
(define (branch-length branch)
  (car branch))
(define (left-branch mobile)
  (car mobile))

(define (mobile? structure)
  (not (number? structure)))

(define (balanced? mobile)
  (let* ([left (left-branch mobile)]
         [right (right-branch mobile)]
         [left-structure (branch-structure left)]
         [right-structure (branch-structure right)])
    (and (or (not (mobile? left-structure))
             (balanced? left-structure))
         (or (not (mobile? right-structure))
             (balanced? right-structure))
         (= (branch-weight left) (branch-weight right)))))

(define (branch-weight b)
  (* (branch-length b)
     (let ([structure (branch-structure b)])
       (cond
         [(number? structure) structure]
         [(null? (cdr structure)) (car structure)]
         [else (total-weight structure)]))))

(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

;------------------------------------------------------------------------------
; Constructors and right-Selectors using `list`
;------------------------------------------------------------------------------
(define (make-mobile-list left right)
  (list left right))
(define (right-branch-list mobile)
  (car (cdr mobile)))

(define (make-branch-list length structure)
  (list length structure))
(define (branch-structure-list branch)
  (car (cdr branch)))

;------------------------------------------------------------------------------
; Constructors and right-Selectors using `cons`
;------------------------------------------------------------------------------
(define (make-mobile-cons left right)
  (cons left right))
(define (right-branch-cons mobile)
  (cdr mobile))

(define (make-branch-cons length structure)
  (cons length structure))
(define (branch-structure-cons branch)
  (cdr branch))

;------------------------------------------------------------------------------
; Configuration for testing
;------------------------------------------------------------------------------
(define make-mobile make-mobile-cons)
(define right-branch right-branch-cons)
(define make-branch make-branch-cons)
(define branch-structure branch-structure-cons)

(cond
  [(odd? 1)
   (printf ">>> Using `cons` as backing mechanism\n")]
  [else
   (set! make-mobile make-mobile-list)
   (set! right-branch right-branch-list)
   (set! make-branch make-branch-list)
   (set! branch-structure branch-structure-list)
   (printf ">>> Using `list` as backing mechanism\n")])

;------------------------------------------------------------------------------
; Testing
;------------------------------------------------------------------------------
(define x
  (make-mobile ;
   (make-branch 2
                (make-mobile (make-branch 1 4)
                             (make-branch 2 2)))
   (make-branch 4
                (make-mobile (make-branch 2 1)
                             (make-branch 1 2)))))

x
(total-weight x)
(balanced? x)
