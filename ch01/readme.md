# 1. Building Abstractions with Procedures

<!-- toc -->

- [1.1 The Elements of Programming](#11-the-elements-of-programming)
  * [1.1.1 Expressions](#111-expressions)
  * [1.1.2 Naming and the Environment](#112-naming-and-the-environment)
  * [1.1.3 Evaluating Combinations](#113-evaluating-combinations)
  * [1.1.4 Compound Procedures](#114-compound-procedures)
  * [1.1.5 The Substitution Model for Procedure Application](#115-the-substitution-model-for-procedure-application)
  * [1.1.6 Conditional Expressions and Predicates](#116-conditional-expressions-and-predicates)
    + [Exercises](#exercises)
  * [1.1.7 Example: Square Roots by Newton's Method](#117-example-square-roots-by-newtons-method)
    + [Exercises](#exercises-1)
  * [1.1.8 Procedures as Black-Box Abstractions](#118-procedures-as-black-box-abstractions)
- [1.2 Procedures and the Processes They Generate](#12-procedures-and-the-processes-they-generate)
  * [1.2.1 Linear Recursion and Iteration](#121-linear-recursion-and-iteration)
    + [Exercises](#exercises-2)
  * [1.2.2 Tree Recursion](#122-tree-recursion)
  * [1.2.3 Orders of Growth](#123-orders-of-growth)
  * [1.2.4 Exponentiation](#124-exponentiation)
  * [1.2.5 Greatest Common Divisors](#125-greatest-common-divisors)
  * [1.2.6 Example: Testing for Primality](#126-example-testing-for-primality)
- [1.3 Formulating Abstractions with Higher-Order Procedures](#13-formulating-abstractions-with-higher-order-procedures)
  * [1.3.1 Procedures as Arguments](#131-procedures-as-arguments)
  * [1.3.2 Constructing Procedures Using Lambda](#132-constructing-procedures-using-lambda)
  * [1.3.3 Procedures as General Methods](#133-procedures-as-general-methods)
  * [1.3.4 Procedures as Returned Values](#134-procedures-as-returned-values)

<!-- tocstop -->

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

Footnote 4 is eye-opening: number is not so _simple_. It's, in fact, one of a
trickiest and confusing aspect of any programming language.

- Is $2$ same or different with $2.0$?
- $6/2$ results in $2$ or $2.0$?
- Physical limitation of representing a large number
- ...

These links might be relevant on this topic:

- [Mathematician Reveals 'Equals' Has More Than One Meaning in Math](https://www.sciencealert.com/mathematician-reveals-equals-has-more-than-one-meaning-in-math)
  - [HN discussion](https://news.ycombinator.com/item?id=40702895)
    - [This particular thread on whether 1 integer is the same with 1 real number](https://news.ycombinator.com/item?id=40714090)
- [Are real numbers real?](https://ptolemy.berkeley.edu/~eal/pnerd/blog/are-real-numbers-real.html)
  - [HN discussion](https://news.ycombinator.com/item?id=33316803)

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

The more syntactic sugar, the less uniform of the language. Great quote.

> Syntactic sugar causes cancer of the semicolon.
>
> -- Alan Perlis,

### 1.1.4 Compound Procedures

There's 2 different actions being combined in the line:

```racket
(define (square x) (* x x))
```

- _Creating_ a procedure
- Give it a name

It's important to be able to separate these 2 actions, so that:

- We could create a procedure without giving it a name, i.e. Anonymous function.
- We could give a name to an existed procedure, i.e. Higher-order function.

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

The algorithm discussed in this section is just a special case of Newton's
method to find roots of equations.

#### Exercises

- [1.6](./1.6.md)
- [1.7](./1.7.md)
- [1.8](./1.8.md)

### 1.1.8 Procedures as Black-Box Abstractions

A procedure definition should be able to suppress detail. The users may consider
it a _black box_, be able to use it without knowing how it's implemented.

Both of these compute the square of a number, to illustrate the black box idea.

```racket
(define (square x) (* x x))

(define (square x)
  (exp (double (log x))))
(define (double x)
  (+ x x))

```

The 2nd version is $square(x) = 2^{2*\log_2{x}}$. Proof:

$$
\begin{align}
& \text{Let } y = \log_2(x)
\\
& \text{then } 2^{2y} = (2^{y})^2 = x^2
\end{align}
$$

From [footnote 25](https://sarabander.github.io/sicp/html/1_002e1.xhtml#DOCF25),
despite 2nd version is more complicated, it might be even faster than the
obvious version if the hardware has extensive and efficient tables of logarithms
and antilogarithms.

Kinds of variable:

- **Bound**: variables that is formally defined by the procedure signature, or
  within a _scope_.
- **Free**: unbounded variables.

Nesting of procedure definitions is called **block structure**. It's the
solution for name-packaging problem, and also provide the benefit of simplify
internal procedures by make use of enclosing procedure scoped variables, e.g.
**Lexical scoping**.

> Free variables in a procedure are taken to refer to bindings made by enclosing
> procedure definitions; that is, they are looked up in the environment in which
> the procedure was defined).

## 1.2 Procedures and the Processes They Generate

https://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2

After 1.1, we know: primitive arithmetic operations, how to combine them, define
compound procedures. We still lacking

- Knowledge of common patterns (which procedures are worth defining).
- Experience to predict the consequences of executing procedures.

> learn to visualize the processes generated by various types of procedures,
> ..., reliably construct programs that exhibit the desired behavior.

This section:

- Examine common _shapes_ of processes generated by simple procedures.
- Introduce the concepts of algorithm complexity.

### 1.2.1 Linear Recursion and Iteration

Example _shapes_ of 2 methods for [`./factorials.rkt`](./factorials.rkt).

- Recursive: stack expands then contracts, interpreter needs to keep track of
  the chain of processes, thus, requires _hidden_ information (not declared by
  the variables), program can't resume from a particular steps without those
  hidden info.

  ```racket
  (fact 2)
  (* 2 (fact 1))
  (* 2 (* 1 (fact 0)))
  (* 2 (* 1 1))
  (* 2 1)
  2
  ```

- Iteration: stack stays the same, all information are maintained using
  variables, program can resumes from any particular step.

  ```racket
  (fact 2)
  (iter 1 1)
  (iter 1 2)
  2
  ```

Don't confuse between a recursive _process_ and a recursive _procedure_. `iter`
is a recursive procedure, but its process generating an _iteractive_ pattern.
Languages, compilers or runtime that support _tail-recursive_ will execute those
recursive but iteractive processes using constant space, i.e. [Tail call
optimization](https://en.wikipedia.org/wiki/Tail_call).

#### Exercises

- [1.9](./1.9.md)
- [1.10](./1.10.md)

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
