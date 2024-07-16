#lang racket

(require "../../utils/debug.rkt")

;------------------------------------------------------------------------------
; My 1st attempt at solving the 8 queens puzzle.
; The code works, looks clean enough.
; However, the design is still not performance enough, because
;
; - Using `list-ref` to check cell, which is a slow iterative process
; - Still generate tons of boards.
;
; The data structure should be redesigned to reduces memory usage.
; For each row, we only need to stores the queen's column.
;------------------------------------------------------------------------------
(define (my-queens-1 board-size)
  (define cols (range board-size))

  (define (place col)
    (map (lambda (c) (if (= c col) 1 0)) cols))

  (define (safe? board col)
    (define (unsafe i remain)
      (if (empty? remain)
          false
          (let* ([row (car remain)] ;
                 [row-id (+ i 1)]
                 [diag-left (- col row-id)]
                 [diag-right (+ col row-id)])
            ; queen is placed at same column
            (or (= 1 (list-ref row col))
                ; queen is placed at either diagonal
                ; note that the new queen is placed at 0 row
                (and (>= diag-left 0)
                     (= 1 (list-ref row diag-left)))
                (and (< diag-right board-size)
                     (= 1 (list-ref row diag-right)))
                (unsafe row-id (cdr remain))))))
    (not (unsafe 0 board)))

  (define (add-queen boards)
    (lambda (col)
      (map (lambda (b)
             (if (safe? b col) (cons (place col) b) null))
           boards)))

  (define (try-next boards)
    (foldr append null (map (add-queen boards) cols)))

  (define (next boards)
    (filter pair? (try-next boards)))

  (define (solve row boards)
    (if (= row board-size)
        boards
        (solve (+ 1 row) (next boards))))

  (solve 1 (map list (map place cols))))

;-----------------------------------------------------------
; Book's solution
; This is easier to understand than mine.
; And, the simpler encoding makes it faster.
;
; However, it can still be improved.
; We only need to store either row or column.
; The other can be derived by list index.
;-----------------------------------------------------------

(define enumerate-interval inclusive-range)

(define (flatmap proc seq)
  (foldr append null (map proc seq)))

(define (book-queens board-size)
  (define empty-board (list))

  (define (safe? col positions)
    (define row (car (car positions)))
    (define (unsafe remain)
      (if (empty? remain)
          false
          (let* ([pos (car remain)]
                 [r (car pos)]
                 [c (cdr pos)])
            (or (= r row) ; same row with the new queen
                (= (- r row) (- c col)) ; same diagonal
                (= (- r row) (- col c)) ; other diagonal
                (unsafe (cdr remain))))))

    ; ignore first position, which is for the new queen.
    (not (unsafe (cdr positions))))

  (define (adjoin-position row col rest-of-queens)
    (cons (cons row col) rest-of-queens))

  (define (queen-cols col)
    (if (= col 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? col positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (row)
                   (adjoin-position row col rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- col 1))))))

  (queen-cols board-size))

;-----------------------------------------------------------
; Trials
;-----------------------------------------------------------
(define (show-board board)
  (for ([row board])
    (show row)))

(define (build-book-board positions)
  (define n (length positions))
  (map (lambda (pos)
         (let ([row (car pos)])
           (map (lambda (r) (if (= r (- row 1)) 1 0))
                (range n))))
       positions))

(define size 4)

(define book (book-queens size))
(debug book)

(for ([b book] [i (in-naturals)])
  (printf "---------------\n")
  (printf "Solution ~a \n" (+ 1 i))
  (printf "---------------\n")
  (show-board (build-book-board b)))

(define mine (my-queens-1 size))
(debug mine)
(for/last ([b mine] [i (in-naturals)])
  (printf "---------------\n")
  (printf "Solution ~a \n" (+ 1 i))
  (printf "---------------\n")
  (show-board b))
