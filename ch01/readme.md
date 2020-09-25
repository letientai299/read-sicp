# 1. Building Abstractions with Procedures

## 1.1 The Elements of Programming

- [x] 1.1.1 Expressions
- [x] 1.1.2 Naming and the Environment
- [x] 1.1.3 Evaluating Combinations
- [x] 1.1.4 Compound Procedures
- [x] 1.1.5 The Substitution Model for Procedure Application
  - Substitution models:
    - Normal order: fully expand before reduce.
    - Applicative order: **evaluate the argument** before apply
- [x] 1.1.6 Conditional Expressions and Predicates
- [x] 1.1.7 Example: Square Roots by Newton�s Method
- [x] 1.1.8 Procedures as Black-Box Abstractions

## 1.2 Procedures and the Processes They Generate

- [x] 1.2.1 Linear Recursion and Iteration

  - Recursive: operate on the result of the called function, after calling it.
  - Iteractive: operate on the argument of the called function, before calling
    it.
  - What is Ackermann function? How useful is it? And why do I see it many
    so times without knowing its usage?

- [x] 1.2.2 Tree Recursion

  - Here we learn about the classic Fibonacci.
  - The "Counting change" example feels like old BFS examples that I used to
    solved during CS course.
  - Tree recursive is easy to implemented than Iteractive process.
  - Are there any Iteractive solution for the count-change?

- [x] 1.2.3 Orders of Growth

  - `R(n) = Θ(f(n))` if there's `k1` and `k2` such that `R(n)` is sandwiched
    between `k1.f(n)` and `k2.f(n)`
  - How to debug in Racket?
  - How to return multiple values (for log debugging)?
  - And how to have side-effect (print to console) feature in racket?
  - Now sure where's the first place I read those, but:
  - Θ is used for sandwiched.
  - Ο is used for upper bound, and
  - Ω is used for lower bound.
  - Don't know why big-O is popular instead of Θ, while Θ should be the
    thing we consider when analyze the complexity of algorithm.

- [x] 1.2.4 Exponentiation

  - ~~I don't get it. Why compute `b^n` is `Θ(n)` space? It should be `Θ(1)` to
    me.~~ I get it now, thanks to https://cs.stackexchange.com/a/44602
  - `f(n)` consumes 1 more than `f(n-1)`, thus the space is `Θ(n)`
  - I really miss the side effect of `println` or `console.log()`.

- [x] 1.2.5 Greatest Common Divisors

  - It's funny when you are working through SICP, and they mention TAOCP,
    which you also working through as the same time. I' choose to work on
    SICP because Knuth volume 1 requires too much Math, such that I can't
    programming. And SICP seems easier to code. Doing both seems a good
    balance between hand writing mathematic and proramming in a completely
    new language.
  - How to prove Lamé's Theorem?

- [ ] 1.2.6 Example: Testing for Primality

## 1.3 Formulating Abstractions with Higher-Order Procedures

- [ ] 1.3.1 Procedures as Arguments

- [ ] 1.3.2 Constructing Procedures Using Lambda

- [ ] 1.3.3 Procedures as General Methods

- [ ] 1.3.4 Procedures as Returned Values
