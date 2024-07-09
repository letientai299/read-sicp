#lang racket

(require "./higher-order-procedures.rkt")
(require plot)

; Create T_n function that transform x to a/(x^n).
(define (T n a)
  (lambda (x) (/ a (expt x n))))

; Compute q_n = 1/(n+1).
(define (q_n n)
  (/ 1 (+ n 1)))

; Compute p_n = 1 - q_n
(define (p_n n)
  (- 1 (q_n n)))

; Create S_n function that average x and T_n(x) value
; using the p_n and q_n ratio discovered in our analysis.
(define (S n a)
  (let ([p (p_n n)] [q (q_n n)])
    (lambda (x)
      ; compute y as the tranformed value after applying T_n on x
      (let ([y ((T n a) x)])
        ; return px + qy
        (+ (* p x) (* q y))))))

; Approximate nth root of a using fixed point algorithm
; with the S_n function, returning only the final result.
(define (nth-root n a guess)
  (car (nth-root-guesses n a guess)))

; Approximate nth root of a using fixed point algorithm with the S_n function,
; returning all the intemediate guesses in reverse order.
(define (nth-root-guesses n a guess)
  (define f (S (- n 1) a))
  (fixed-point-guesses f guess))

(define (r_n n)
  (floor (log (inc n) 2)))

; Create S_n function that average x and T_n(x) value
; using the average damping technique.
(define (S-avg-damp n a)
  (let* ([r (r_n n)]
         [q (/ 1 (expt 2 r))]
         [p (- 1 q)]
         [f (T n a)])
    (lambda (x) (+ (* p x) (* q (f x))))))

(define (nth-root-guesses-log2-damps n a guess)
  (define f (S-avg-damp (- n 1) a))
  (fixed-point-guesses f guess))

; nth root function that require setting q_n manually
(define (make-nth-root-guesses-custom-q q_n)
  (lambda (n a guess)
    (define t (T (- n 1) a))
    (define f
      (let ([p (- 1 q_n)])
        (lambda (x) (+ (* p x) (* q_n (t x))))))
    (fixed-point-guesses f guess)))

(define (show-guessed-values n a guess methods names)
  (define (get-or-empty sq)
    (if (empty? sq) "" (car sq)))

  (define (get-values sequences)
    (if (empty? sequences)
        (list)
        (let ([sq (car sequences)])
          (append (list (get-or-empty sq))
                  (get-values (cdr sequences))))))

  (define (next sequences)
    (if (empty? sequences)
        (list)
        (let ([sq (car sequences)])
          (append (list (if (empty? sq) (list) (cdr sq)))
                  (next (cdr sequences))))))

  (define value-width 25)
  (define iter-num-width 5)
  (define target (expt a (/ 1.0 n)))

  (define (show-header)
    (printf "\n~a " (~a "ID" #:width iter-num-width))
    (for ([name names])
      (printf "| ~a | ~a "
              (~a name #:width value-width)
              (~a "Diff" #:width value-width)))

    (printf "\n~a " (line iter-num-width))
    (for ([_ (length names)])
      (printf "| ~a | ~a "
              (line value-width)
              (line value-width)))
    (printf "\n"))

  (define (show-values len i sequences)
    (let ([guesses (get-values sequences)])
      (printf "~a " (~a i #:width iter-num-width))

      (for ([guess guesses])
        (if (number? guess)
            (let* ([err (- guess target)]
                   [prefix (if (< 0 err) "+" "")]
                   [err-width (if (< 0 err)
                                  (- value-width 1)
                                  value-width)])
              (printf "| ~a | ~a~a "
                      (~a guess #:width value-width)
                      prefix
                      (~a err #:width err-width)))
            (printf "| ~a | ~a "
                    (spaces value-width)
                    (spaces value-width))))

      (newline)
      (when (> len i)
        (show-values len (inc i) (next sequences)))))

  (define (line n)
    (~a "" #:pad-string "-" #:width n))

  (define (spaces n)
    (~a "" #:pad-string " " #:width n))

  (printf "\n## n=~a, a=~a, guess=~a --> target=~a \n"
          n
          a
          guess
          target)
  (show-header)

  (let* (; ensure that output is floating point
         [g (* 1.0 guess)]
         [sequences (map (lambda (method)
                           (reverse (method n a g)))
                         methods)]
         [len (foldl max 0 (map length sequences))])
    (show-values len 1 sequences)))

(define (experiment N A G q_n)
  (show-guessed-values
   N
   A
   G
   (list nth-root-guesses
         nth-root-guesses-log2-damps
         (make-nth-root-guesses-custom-q q_n))
   (list "My finding"
         (format "$r=~a$ damps" (inexact->exact (r_n N)))
         (format "Custom $q_n=~a$" q_n))))

(define (power-of-2? n)
  (= (expt 2 (r_n n)) n))

(define A 10)
(define custom-q_n (/ 1 21))
(printf "# Experimental stats for 1.45\n")

(for ([n (in-inclusive-range 2 20)])
  (define target (expt A (/ 1.0 n)))
  (define near-lower (floor target))
  (define near-higher (ceiling target))
  (when (not (power-of-2? n))
    (experiment n A near-lower custom-q_n)
    (experiment n A near-higher custom-q_n)
    (experiment n A (- (/ A 2)) custom-q_n)
    (experiment n A (/ A 2) custom-q_n)
    (experiment n A (- A) custom-q_n)
    (experiment n A A custom-q_n)
    (experiment n A (* A -100) custom-q_n)
    (experiment n A (* A 100) custom-q_n)))
