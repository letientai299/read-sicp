#lang racket

(provide (all-defined-out))

(require "../../utils/debug.rkt")

(define (entry tree)
  (car tree))

(define (left-node tree)
  (cadr tree))

(define (right-node tree)
  (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (make-leaf val)
  (if (null? val) null (make-tree val null null)))

(define (leaf? node)
  (and (not (null? node))
       (null? (left-node node))
       (null? (right-node node))))

(define (in? x set)
  (if (null? set)
      false
      (let ([y (entry set)])
        (cond
          [(= x y) true]
          [(> x y) (in? x (right-node set))]
          [else (in? x (left-node set))]))))

(define (adjoin x set)
  (if (null? set)
      (make-tree x null null)
      (let ([y (entry set)] ;
            [l (left-node set)]
            [r (right-node set)])
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
      (walk (left-node node) (+ 1 depth))
      (walk (right-node node) (+ 1 depth))))
  (walk tree 0))

(define (fmt-mermaid-generic tree entry-fmt direction-fmt)
  (define (walk parent left? node)
    (when (not (null? node))
      (when (not (null? parent))
        (printf "  ~a -- ~a --> ~a\n"
                (entry-fmt (entry parent))
                (direction-fmt left?)
                (entry-fmt (entry node))))
      (walk node true (left-node node))
      (walk node false (right-node node))))
  (printf "graph TD;\n")
  (if (leaf? tree)
      (printf "  ~a\n" (entry-fmt (entry tree)))
      (walk null false tree)))

(define (fmt-mermaid tree)
  (define (entry-fmt val)
    (let* ([str (~a val)]
           [id (string-replace (string-replace str " " "-")
                               (regexp "[()]")
                               "")])
      (format "~a[\"~a\"]" id str)))
  (define (direction-fmt left?)
    (if left? "L" "R"))

  (fmt-mermaid-generic tree entry-fmt direction-fmt))

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
        (let* ([cur (walk res (right-node node))]
               [cur (cons (entry node) cur)])
          (walk cur (left-node node)))))
  (walk null t))

(define (tree->list-with-append t)
  (if (null? t)
      null
      (append (tree->list-with-append (left-node t))
              (cons (entry t)
                    (tree->list-with-append
                     (right-node t))))))

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
; More tree helpers
;-----------------------------------------------------------
(require racket/trace)

(define (nth-or-null n vs)
  (cond
    [(null? vs) null]
    [(= 0 n) (car vs)]
    [else (nth-or-null (- n 1) (cdr vs))]))

(define (list-of n val)
  (build-list n (lambda (_) val)))

(define (level-order->tree vs)
  ; split the input into multiple levels,
  ; the result should be in reversed orders,
  ; so that we can build the tree from leaves to root.
  (define (split non-nil-nodes levels children data)
    (cond
      [(null? data)
       (cons (append (list-of children null) (car levels))
             (cdr levels))]
      [(= children 0)
       (split 0
              (cons (list) levels)
              (* 2 non-nil-nodes)
              data)]
      [else
       (let* ([val (car data)]
              [node (if (eq? val 'nil) null val)]
              [remain (cdr data)]
              [top (car levels)]
              [others (cdr levels)])
         (split (if (null? node)
                    non-nil-nodes
                    (+ 1 non-nil-nodes))
                (cons (cons node top) others)
                (- children 1)
                remain))]))

  ; build the tree from leaves to root
  ;
  ; This works by building the middle-nodes using
  ; - value from 1st layer of the stack
  ; - left and right node from the chidlren list
  ;
  ; Once 1st layer of the stack is empty,
  ; the middle-nodes become the children for next layer.
  ;
  ; The stack is empty when the chidlren contains only the root node.
  (define (build children middles stack)
    (cond
      [(null? stack) children]
      [(null? (car stack))
       (build (reverse middles) null (cdr stack))]
      [else
       (let* ([top (car stack)]
              [val (car top)]
              [right (nth-or-null 0 children)]
              [left (nth-or-null 1 children)]
              [leaves (if (>= 2 (length children))
                          null
                          (drop children 2))])

         (build leaves
                (if (null? val)
                    middles
                    (cons (make-tree val left right)
                          middles))
                (cons (cdr top) (cdr stack))))]))

  (if (null? vs)
      null
      (let* (; init the levels that contains a list of the root node
             [levels (list (list (car vs)))]
             ; split the remaining data into levels
             ; based on expected children counts.
             [data (split 1 levels 0 (cdr vs))]
             ; prepare the leaf-nodes
             [leaves (map make-leaf (car data))])
        ; build the tree, the output should contains a list of a
        ; single sub-list, which contains the root node.
        (car (build leaves null (cdr data))))))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------

(save-md "temp.md"
         (define t (level-order->tree (range 1 14)))
         (md-text "# temp")
         (md-fence "mermaid" (fmt-mermaid t)))
