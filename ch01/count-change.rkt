#lang racket

; -----------------------------------------------------------------------------
; Code from the book.
; -----------------------------------------------------------------------------

; count-change procedure provided by the book.
;
; Note that at this point in the book, we haven't learn about data structure.
; Hence, the authors didn't define this function to take a list of coins.
; Instead, they define the first-denomination function to translate from coin
; index to its value.
(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coints)
  (cond
    [(= amount 0) 1]
    [(or (< amount 0) (= kinds-of-coints 0)) 0]
    [else
     (+ (cc amount (- kinds-of-coints 1))
        (cc (- amount (first-denomination kinds-of-coints))
            kinds-of-coints))]))

(define (first-denomination kinds-of-coints)
  (cond
    [(= kinds-of-coints 1) 1]
    [(= kinds-of-coints 2) 5]
    [(= kinds-of-coints 3) 10]
    [(= kinds-of-coints 4) 25]
    [(= kinds-of-coints 5) 50]))

; -----------------------------------------------------------------------------
; Code to analyze order of growth and visualize the call tree
; -----------------------------------------------------------------------------
(define max-kinds 5)
(define depth-start 1)

(define (count-change-visualized amount)
  (cc-stat amount max-kinds depth-start))

; This is the modified `cc` procedure to generate the call graph for order of
; growth analysis in exercise 1.14.
(define (cc-stat amount kinds depth)
  (define call-args (args amount kinds depth))
  (cond
    [(= amount 0) (stat 1 (list call-args))]
    [(or (< amount 0) (= kinds 0))
     (stat 0 (list call-args))]
    [else
     (let ([left-stat
            (cc-stat amount (- kinds 1) (+ 1 depth))]
           [right-stat (cc-stat ;
                        (- amount
                           (first-denomination kinds))
                        kinds
                        (+ 1 depth))])
       (combine-stat call-args left-stat right-stat))]))

; custom structure to support the analysis
; result: the final output
; calls collect arguments for each time cc-stat get called
(struct stat (result calls) #:transparent)
(struct args (amount kinds depth) #:transparent)

(define (combine-stat args left right)
  (stat (+ (stat-result left) (stat-result right))
        (append (list args)
                (stat-calls left)
                (stat-calls right))))

; print a markdown table for all the given stats,
(define (show stats)
  (define (show-stat-header)
    (printf "| amount | kinds | result | steps | depth |\n")
    (printf
     "| ------ | ----- | ------ | ----- | ----- |\n"))

  (define (show-one stat)
    (define calls (stat-calls stat))
    (define first-args (first calls))
    (define steps (length calls))
    (define max-depth (foldl max 0 (map args-depth calls)))
    (define amt (args-amount first-args))
    (define kinds (args-kinds first-args))
    (printf "| ~a | ~a | ~a | ~a | ~a |\n"
            amt
            kinds
            (stat-result stat)
            steps
            max-depth))
  (show-stat-header)
  (for ([st stats])
    (show-one st)))

(define (visualize stat)
  (for ([args (stat-calls stat)])
    (visualize-wbs (args-amount args)
                   (args-kinds args)
                   (args-depth args))))

; visualize-wbs uses plantuml Work Breakdown Structure to visual the call tree
; https://plantuml.com/wbs-diagram
(define (visualize-wbs amount kinds depth)
  (define color
    (cond
      [(= amount 0) "[#green]"]
      [(or (< amount 0) (= kinds 0)) "[#tomato]"]
      [else ""]))
  (printf "~a~a (cc ~a ~a ~a)\n" ;
          (string-repeat "+" depth)
          color
          amount
          kinds
          depth))

; return a string which is a repeated n times of the given str.
(define (string-repeat str n)
  (string-join (make-list n str) ""))

; code to verify and test the visualization for ex 1.14
; (define stat-11 (count-change-visualized 11))
; (show (list stat-11))
; (visualize stat-11)

; generate some data to analyze count-change order of growth
(define (gen-data)
  (define stats
    (flatten (map (lambda (amt)
                    (map (lambda (n)
                           (cc-stat amt n depth-start))
                         (inclusive-range 1 max-kinds)))
                  (inclusive-range 10 20))))
  (show stats))

(gen-data)
