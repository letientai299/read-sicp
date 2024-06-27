# 1. Building Abstractions with Procedures

https://sarabander.github.io/sicp/html/Chapter-1.xhtml

Lisp:

- **LIS**t **P**rocessing
- Experimental as first, emphasis on symbol manipulation.
- A family of dialects, Scheme (the dialect the book is using) is one of them.

## 1.1 The Elements of Programming

https://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1

Mechanisms to combine simple ideas to form more complex ideas.

- **Primitive** expressions.
- Means of **combination**
- Means of **abstraction**: compound elements can be named and used as units.

### 1.1.1 Expressions

Prefix notation advantages:

- Arbitrary number of operands.
- Straight forward nested combinations.

### 1.1.2 Naming and the Environment

### 1.1.3 Evaluating Combinations

- Tree accumulation: treat expression as a tree, percolate value upward.
- Lisp simple syntax: evaluation rule for expressions can be described by a
  simple general rule together with specialized rule for a small number of
  special forms (`define` is one of them).

### 1.1.4 Compound Procedures

### 1.1.5 The Substitution Model for Procedure Application

- Applicative order: _evaluate args and then apply_.
- Normal order: _fully expand and then reduce_, leads to duplicated evaluation.
- Normal and Applicative orders don't always produce the same result.

- Substitution models:
  - Helps with the thinking process, not actually how the interpreter works.
  - There are more evaluation models.
- Evaluations orders:
  - **Normal** order: _fully expand before reduce_, can leads to duplicated
    evaluations.
  - **Applicative** order: _evaluate the argument before apply_
  - The 2 orders don't always yield the same result.

### 1.1.6 Conditional Expressions and Predicates

_Case analysis_ in Lisp, basically a more powerful _switch-case_.

Verbose example

```racket
(define (abs x)
  (cond
    ((> x 0) x)
    ((= x 0) 0)
    ((< x 0) (- x))))
```

Shorter

```racket
(define (abs x)
  (cond
    ((< x 0) (- x))
    (else x)))
```

`if` syntax.

```racket
(define (abs x)
  (if (< x 0) (- x) x))
```

_Predicate_: procedure that return true or false, or expression that evaluate to
true or false.

#### Exercises

- [1.1](./1.1.md)
- [1.2](./1.2.md)
- [1.3](./1.3.md)
- [1.4](./1.4.md)
- [1.5](./1.5.md)

### 1.1.7 Example: Square Roots by Newton's Method

Unlike mathematical functions, _procedures must be effective_.

| Math function               | Computer procedure       |
| --------------------------- | ------------------------ |
| Describe property of things | Describe how to do thing |
| Declarative                 | Imperative               |

Radicand: the $x$ in $\sqrt{x}$ (I'm not familiar with math in English).

#### Exercises

- [1.6](./1.6.md)
- [1.7](./1.7.md)
- [1.8](./1.8.md)

### 1.1.8 Procedures as Black-Box Abstractions

## 1.2 Procedures and the Processes They Generate

### 1.2.1 Linear Recursion and Iteration

- Recursive: operate on the result of the called function, after calling it.
- Iteractive: operate on the argument of the called function, before calling
  it.
- What is Ackermann function? How useful is it? And why do I see it many
  so times without knowing its usage?

### 1.2.2 Tree Recursion

- Here we learn about the classic Fibonacci.
- The "Counting change" example feels like old BFS examples that I used to
  solved during CS course.
- Tree recursive is easy to implemented than Iteractive process.
- Are there any Iteractive solution for the count-change?

### 1.2.3 Orders of Growth

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

### 1.2.4 Exponentiation

- ~~I don't get it. Why compute `b^n` is `Θ(n)` space? It should be `Θ(1)` to
  me.~~ I get it now, thanks to https://cs.stackexchange.com/a/44602
- `f(n)` consumes 1 more than `f(n-1)`, thus the space is `Θ(n)`
- I really miss the side effect of `println` or `console.log()`.

### 1.2.5 Greatest Common Divisors

- It's funny when you are working through SICP, and they mention TAOCP,
  which you also working through as the same time. I' choose to work on
  SICP because Knuth volume 1 requires too much Math, such that I can't
  programming. And SICP seems easier to code. Doing both seems a good
  balance between hand writing mathematic and proramming in a completely
  new language.
- How to prove Lamé's Theorem?

### 1.2.6 Example: Testing for Primality

## 1.3 Formulating Abstractions with Higher-Order Procedures

### 1.3.1 Procedures as Arguments

### 1.3.2 Constructing Procedures Using Lambda

### 1.3.3 Procedures as General Methods

### 1.3.4 Procedures as Returned Values
