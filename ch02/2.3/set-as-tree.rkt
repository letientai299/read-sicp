#lang racket

(require "../../utils/debug.rkt")

(define (entry tree) ; value
  (car tree))

(define (left tree)
  (cadr tree))

(define (right tree)
  (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (in? x set)
  (if (null? set)
      false
      (let ([y (entry set)])
        (cond
          [(= x y) true]
          [(> x y) (in? x (right set))]
          [else (in? x (left set))]))))

(define (adjoin x set)
  (if (null? set)
      (make-tree x null null)
      (let ([y (entry set)] ;
            [l (left set)]
            [r (right set)])
        (cond
          [(= x y) set]
          [(> x y) (make-tree y l (adjoin x r))]
          [else (make-tree y (adjoin x l) r)]))))

(define (intersect a b)
  (define (collect la lb)
    (if (or (null? la) (null? lb))
        null
        (let ([x (car la)] [y (car lb)])
          (cond
            [(= x y) (cons x (collect (cdr la) (cdr lb)))]
            [(> x y) (collect la (cdr lb))]
            [else (collect (cdr la) lb)]))))
  (list->tree (collect (tree->list-no-append a)
                       (tree->list-no-append b))))

(define (union a b)
  (define (collect la lb)
    (cond
      [(null? la) lb]
      [(null? lb) la]
      [else
       (let ([x (car la)] [y (car lb)])
         (cond
           [(= x y) (cons x (collect (cdr la) (cdr lb)))]
           [(> x y) (cons y (collect la (cdr lb)))]
           [else (cons x (collect (cdr la) lb))]))]))
  (list->tree (collect (tree->list-no-append a)
                       (tree->list-no-append b))))

;-----------------------------------------------------------
; Drawing tree
;-----------------------------------------------------------
(define (fmt-tree tree)
  (define (walk node depth)
    (when (not (null? node))
      (printf "~a ∟ ~a\n"
              (string-repeat "  " depth)
              (entry node))
      (walk (left node) (+ 1 depth))
      (walk (right node) (+ 1 depth))))
  (walk tree 0))

(define (fmt-mermaid tree)
  (printf "graph TD;\n")
  (define (walk parent left? node)
    (when (not (null? node))
      (when (not (null? parent))
        (printf "  ~a -- ~a --> ~a\n"
                (entry parent)
                (if left? "L" "R")
                (entry node)))
      (walk node true (left node))
      (walk node false (right node))))
  (walk null false tree))

;-----------------------------------------------------------
; Ex 2.63
;-----------------------------------------------------------
(define fig-2.16-t1
  (make-tree 7
             (make-tree 3
                        (make-tree 1 null null)
                        (make-tree 5 null null))
             (make-tree 9 null (make-tree 11 null null))))

(define fig-2.16-t2
  (make-tree
   3
   (make-tree 1 null null)
   (make-tree 7
              (make-tree 5 null null)
              (make-tree 9 null (make-tree 11 null null)))))

(define fig-2.16-t3
  (make-tree 5
             (make-tree 3 (make-tree 1 null null) null)
             (make-tree 9
                        (make-tree 7 null null)
                        (make-tree 11 null null))))

; (save-md "temp.md"
; (md-text "# Temp")
; (define (vis fig name)
; (md-text (format "## ~a" name))
; (md-fence "mermaid" (fmt-mermaid fig))
; (md-text "With append")
; (md-fence ""
; (print (tree->list-with-append fig)))
; (md-text "No append")
; (md-fence "" (print (tree->list-no-append fig))))
; (vis fig-2.16-t1 "Figure 2.16 - 1")
; (vis fig-2.16-t2 "Figure 2.16 - 2")
; (vis fig-2.16-t3 "Figure 2.16 - 3"))

;-----------------------------------------------------------
; Tree <-->> ordered list
;-----------------------------------------------------------

(define (tree->list-no-append t)
  (define (walk res node)
    (if (null? node)
        res
        (let* ([cur (walk res (right node))]
               [cur (cons (entry node) cur)])
          (walk cur (left node)))))
  (walk null t))

(define (tree->list-with-append t)
  (if (null? t)
      null
      (append (tree->list-with-append (left t))
              (cons (entry t)
                    (tree->list-with-append (right t))))))

(define (list->tree vs)
  (define (build start n)
    (if (= n 0)
        (list null start)
        (let* ([left-size (quotient n 2)]
               [right-size (- n left-size 1)]
               [left-result (build start left-size)]
               [left-tree (car left-result)]
               [next (cadr left-result)]
               [right-result (build (cdr next) right-size)]
               [right-tree (car right-result)]
               [remain (cadr right-result)])
          (list (make-tree (car next) left-tree right-tree)
                remain))))

  (car (build vs (length vs))))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

; (define a (list->tree '(1 2 3 5 6 7 8 9 10 11 12 13)))
; (define b (list->tree '(1 2 4 5 7 8 9 10 12)))

; (save-md "temp.md"
; (md-text "# Temp")
; (define (vis fig)
; (md-fence "mermaid" (fmt-mermaid fig)))
; (vis (union a b)))
