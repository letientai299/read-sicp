#lang racket

(require "./set-tree.rkt")
(require "../../utils/debug.rkt")

(define (huffman-leaf symbol weight)
  (make-leaf (cons symbol weight)))
(define (leaf-symbol x)
  (car (entry x)))
(define (leaf-weight x)
  (cdr (entry x)))

(define (huffman-code-tree left right)
  (make-tree (cons (append (huffman-symbols left)
                           (huffman-symbols right))
                   (+ (weight left) (weight right)))
             left
             right))

(define (huffman-symbols node)
  (if (leaf? node) (list (leaf-symbol node)) (caar node)))

(define (weight node)
  (if (leaf? node) (leaf-weight node) (cdar node)))

(define (huffman-decode bits root)
  (define (choose-branch bit branch)
    (cond
      [(= bit 0) (left-node branch)]
      [(= bit 1) (right-node branch)]
      [else (error "bad bit: CHOOSE-BRANCH" bit)]))

  (define (decode-1 bits node)
    (if (null? bits)
        null
        (let ([next (choose-branch (car bits) node)]
              [remain-bits (cdr bits)])
          (if (leaf? next)
              (cons (leaf-symbol next)
                    (decode-1 remain-bits root))
              (decode-1 remain-bits next)))))

  (decode-1 bits root))

(define (huffman-adjoin-set x set)
  (cond
    [(null? set) (list x)]
    [(< (weight x) (weight (car set))) (cons x set)]
    [else
     (cons (car set) (huffman-adjoin-set x (cdr set)))]))

(define (huffman-leaf-set pairs)
  (if (null? pairs)
      null
      (let ([pair (car pairs)])
        (huffman-adjoin-set ;
         (huffman-leaf (car pair) ; symbol
                       (cadr pair)) ; frequence
         (huffman-leaf-set (cdr pairs)) ;
         ))))

(define (huffman-code-table tree)
  (define (walk bits node records)
    (if (leaf? node)
        (let* ([sym (leaf-symbol node)]
               [weight (leaf-weight node)]
               [bits (string-join (map ~a (reverse bits))
                                  "")]
               [steps (string-length bits)]
               [cost (* weight steps)])
          (cons (list sym bits steps weight cost) records))
        (let ([rights (walk (cons 1 bits)
                            (right-node node)
                            records)])
          (walk (cons 0 bits) (left-node node) rights))))
  (walk null tree null))

(define (fmt-huffman-code-table tree)
  (let* ([tab (huffman-code-table tree)]
         [total (foldr + 0 (map fifth tab))]
         [cost-header (format "Cost, ∑=~a" total)])
    (md-table tab
              (list (md-table-header "Symbol" 20)
                    (md-table-header "Code" 20)
                    (md-table-header "Steps" 20)
                    (md-table-header "Weight" 20)
                    (md-table-header cost-header 20)))))

;-----------------------------------------------------------
; Ex 2.67
;-----------------------------------------------------------
(define a (huffman-leaf 'A 4))
(define b (huffman-leaf 'B 2))
(define c (huffman-leaf 'C 1))
(define d (huffman-leaf 'D 1))

(define tree-2.67
  (huffman-code-tree
   a
   (huffman-code-tree b (huffman-code-tree d c))))

(define bits-2.67 '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(debug (huffman-decode bits-2.67 tree-2.67))

;-----------------------------------------------------------
; Ex 2.68
;-----------------------------------------------------------
(define (huffman-encode msg tree)
  (define (encode sym node)
    (let ([left (left-node node)] [right (right-node node)])
      (cond
        [(and (leaf? node) (eq? sym (leaf-symbol node)))
         null]
        [(memq sym (huffman-symbols left))
         (cons 0 (encode sym left))]
        [(memq sym (huffman-symbols right))
         (cons 1 (encode sym right))]
        [else
         (error "unknown symbol: HUFFMAN-ENCODE" sym)])))

  (if (null? tree)
      (error "null huffman tree: HUFFMAN-ENCODE")
      (flatten (map (curryr encode tree) msg))))

(module+ test
  (require rackunit)
  (test-case "encode and decode"
    (define msg (huffman-decode bits-2.67 tree-2.67))
    (define bits (huffman-encode msg tree-2.67))
    (check-equal? bits-2.67 bits)))

;-----------------------------------------------------------
; Ex 2.69
;-----------------------------------------------------------

(define (generate-huffman-tree pairs)
  (define (merge nodes)
    (if (null? (cdr nodes))
        (car nodes)
        (let* ([left (first nodes)]
               [right (second nodes)]
               [meta (huffman-code-tree left right)]
               [rest (drop nodes 2)])
          (merge (huffman-adjoin-set meta rest)))))
  (merge (huffman-leaf-set pairs)))

;-----------------------------------------------------------
; Ex 2.70
;-----------------------------------------------------------
(define tree-2.70
  (generate-huffman-tree '((a 2) (na 16)
                                 (boom 1)
                                 (sha 3)
                                 (get 2)
                                 (yip 9)
                                 (job 2)
                                 (wah 1))))
(define (ex-2.70)
  (define msg
    '(get a
          job
          sha
          na
          na
          na
          na
          na
          na
          na
          na
          get
          a
          job
          sha
          na
          na
          na
          na
          na
          na
          na
          na
          wah
          yip
          yip
          yip
          yip
          yip
          yip
          yip
          yip
          yip
          sha
          boom))
  (define bits (huffman-encode msg tree-2.70))
  (debug (length msg))
  (debug bits)
  (debug (length bits)))

; (ex-2.70)

;-----------------------------------------------------------
; Ex 2.72
;-----------------------------------------------------------

(define (huffman-reverse-symbols-order tree)
  (if (or (null? tree) (leaf? tree))
      tree
      (let ([left (left-node tree)]
            [right (right-node tree)])
        (make-tree
         (cons (reverse (append (huffman-symbols left)
                                (huffman-symbols right)))
               (+ (weight left) (weight right)))
         (huffman-reverse-symbols-order left)
         (huffman-reverse-symbols-order right)))))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------
(define (entry-fmt-huffman val)
  (let* ([syms (car val)]
         [syms (if (list? syms) syms (list syms))]
         [syms-str (string-join (map ~a syms) "")]
         [weight (cdr val)])
    (format "~a[\"~a:~a\"]" syms-str syms weight)))

(define (dir-fmt-huffman left?)
  (if left? 0 1))

(define mermaid
  (curryr fmt-mermaid-generic
          entry-fmt-huffman
          dir-fmt-huffman))

(define (draw t)
  (md-fence "mermaid" (mermaid t)))

(define (gen-pairs n)
  (build-list n
              (lambda (i)
                (list (string->symbol (format "s~a"
                                              (+ 1 i)))
                      (expt 2 i)))))

(debug (gen-pairs 5))

(define t5 (generate-huffman-tree (gen-pairs 5)))
(define t10 (generate-huffman-tree (gen-pairs 10)))

(save-md "temp.md"
         (md-text "# Temp")
         (md-text "### $n=5$")
         (draw t5)
         (fmt-huffman-code-table t5)
         (md-text "### reversed")
         (define r5 (huffman-reverse-symbols-order t5))
         (draw t10)
         (fmt-huffman-code-table t10))
