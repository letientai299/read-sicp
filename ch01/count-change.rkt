#lang debug racket

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

; count-change-dp
; (define (count-change-dp amount)
; (current-process-milliseconds))

(count-change 26)

(define (bench f)
  (define start (current-inexact-monotonic-milliseconds))
  (f)
  (define elapsed
    (- (current-inexact-monotonic-milliseconds) start))
  (define elapsed-ns (truncate (* 1000000 elapsed)))
  (format "Elaspsed ~a ns" (inexact->exact elapsed-ns)))

(define func (lambda () (count-change 200)))

(require atomichron)
(define bench-count-change
  (make-microbenchmark
   #:name 'count-change
   #:iterations 100
   #:microexpression-iterations 200
   #:microexpression-builder
   (lambda (_) (make-microexpression #:thunk func))))
(microbenchmark-run! bench-count-change)
(bench func)
