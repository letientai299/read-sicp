# 1. Building Abstractions with Procedures

<!-- toc -->

- [1.1 The Elements of Programming](#11-the-elements-of-programming)
  - [1.1.1 Expressions](#111-expressions)
  - [1.1.2 Naming and the Environment](#112-naming-and-the-environment)
  - [1.1.3 Evaluating Combinations](#113-evaluating-combinations)
  - [1.1.4 Compound Procedures](#114-compound-procedures)
  - [1.1.5 The Substitution Model for Procedure Application](#115-the-substitution-model-for-procedure-application)
  - [1.1.6 Conditional Expressions and Predicates](#116-conditional-expressions-and-predicates)
    - [Exercises](#exercises)
  - [1.1.7 Example: Square Roots by Newton's Method](#117-example-square-roots-by-newtons-method)
    - [Exercises](#exercises-1)
  - [1.1.8 Procedures as Black-Box Abstractions](#118-procedures-as-black-box-abstractions)
- [1.2 Procedures and the Processes They Generate](#12-procedures-and-the-processes-they-generate)
  - [1.2.1 Linear Recursion and Iteration](#121-linear-recursion-and-iteration)
    - [Exercises](#exercises-2)
  - [1.2.2 Tree Recursion](#122-tree-recursion)
  - [1.2.3 Orders of Growth](#123-orders-of-growth)
  - [1.2.4 Exponentiation](#124-exponentiation)
  - [1.2.5 Greatest Common Divisors](#125-greatest-common-divisors)
  - [1.2.6 Example: Testing for Primality](#126-example-testing-for-primality)
- [1.3 Formulating Abstractions with Higher-Order Procedures](#13-formulating-abstractions-with-higher-order-procedures)
  - [1.3.1 Procedures as Arguments](#131-procedures-as-arguments)
  - [1.3.2 Constructing Procedures Using Lambda](#132-constructing-procedures-using-lambda)
  - [1.3.3 Procedures as General Methods](#133-procedures-as-general-methods)
  - [1.3.4 Procedures as Returned Values](#134-procedures-as-returned-values)

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

Footnote 4 is eye-opening: number is not so _simple_. It's, in fact, one of the
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
  - **Normal** order: _fully expand before reduce_, can lead to duplicated
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

- [x] [1.1](./1.1.md)
- [x] [1.2](./1.2.md)
- [x] [1.3](./1.3.md)
- [x] [1.4](./1.4.md)
- [x] [1.5](./1.5.md)

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

- [x] [1.6](./1.6.md)
- [x] [1.7](./1.7.md)
- [x] [1.8](./1.8.md)

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
> the procedure was defined.

## 1.2 Procedures and the Processes They Generate

https://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2

After 1.1, we know: primitive arithmetic operations, how to combine them, define
compound procedures. We're still lacking

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
  variables, program can resume from any particular step.

  ```racket
  (fact 2)
  (iter 1 1)
  (iter 1 2)
  2
  ```

Don't confuse between a recursive _process_ and a recursive _procedure_. `iter`
is a recursive procedure, but its process generating an _iterative_ pattern.
Languages, compilers or runtime that support _tail-recursive_ will execute those
recursive but iterative processes using constant space, i.e.
[Tail call optimization](https://en.wikipedia.org/wiki/Tail_call).

#### Exercises

- [x] [1.9](./1.9.md)
- [x] [1.10](./1.10.md)

### 1.2.2 Tree Recursion

#### Fibonacci sequence

- Recursive implementation:
  - Time grow exponentially
  - Space grows linearly with the input.
- Linear implementation:
  - Requires noticing that the computation could be recast as an iteration with
    3 state variables.

_Golden ratio_ is the value $\varphi$ that satisfy the following equation:

$$
\varphi^2 = \varphi + 1
$$

See [`./fib.rkt`](./fib.rkt) for all 3 implementation versions: terrible, linear
and $O(1)$.

#### Counting change

- Can be done using BFS
- It's also [Leetcode 518 - Coin Change II][lc-518], a classic _Dynamic
  Programming_ problem.
- Footnote 34 mention the _tabulation_ (or more commonly, _memoization_)
  approach to avoid duplicated work by keep track of computed results, trade
  space for time.

[lc-518]: https://leetcode.com/problems/coin-change-ii

On the different between BFS, DFS, DP and backtracking, all of which are
strategies to explore the _solution **tree/graph**_ for an optimal one:

- **BFS**: explorer the tree _layer by layer_.
- **DFS**: explorer deeply to the leaf first, then go back up and explore other
  branches.
- **DP**:
  - Top to Bottom recursion, enhanced with memorizing smaller solutions, i.e.
    _memoization_.
  - Bottom to Top, solve smaller problems first, remember the solutions, then go
    upward to solve bigger ones, can be implemented iterative typically.
- **Backtracking**: is a brute force approach to solve
  **constraint-satisfaction** problems without trying all possibilities, grow
  the tree as deep as possible, similar to DFS, but also reject invalid branch
  based on the constraint.

Let's use $C(a, n)$ to denote _count change_ value, $a$ is the amount, $n$ is
number of kinds of coin, and $d_n$ is the coin value. Here's how $C(a, n)$ can
be computed.

$$
C(a, n) =
\begin{cases}
1 & \text{if } a = 0   \\
0 & \text{if } a \lt 0 \\
0 & \text{if } n \le 0 \\
C(a, n-1) + C(a-d_n, n)
\end{cases}
$$

See [`./count-change.rkt`](./count-change.rkt).

#### Exercises

- [x] [1.11](./1.11.md)
- [x] [1.12](./1.12.md)
- [x] [1.13](./1.13.md)

### 1.2.3 Orders of Growth

There might be multiple properties of the problem to measure how the algorithm
behave as input change. For example: `sqrt(x)` can use the size of `x`, or `n`
where `n` is the number of digits accuracy required.

$R(n) = \Theta(f(n))$ if there's $k_1$ and $k_2$ such that $R(n)$ is sandwiched
between $k_1f(n)$ and $k_2f(n)$, i.e.

$$
k_1 f(n) <= R(n) <= k_2 f(n) \quad \forall n \text{ large enough}
$$

On the topics of complexity, there's some more knowledge that I know before but
still can get confused when thought about them. Perhaps we will meet them in the
later chapters.

| Notation    | Name      | Meaning    | Set of functions that grow... |
| ----------- | --------- | ---------- | ----------------------------- |
| $O(f)$      | Big O     | Upper      | no faster than $f$            |
| $\Theta(f)$ | Big Theta | Sandwiched | roughly as fast as $f$        |
| $\Omega(f)$ | Big Omega | Lower      | at least as fast as $f$       |

- https://en.wikipedia.org/wiki/Big_O_notation
- [A good explanation](https://www.reddit.com/r/algorithms/comments/13rcitf/comment/jllke3f)

While $\Theta$ is more correct, $O$ is more widely used because we mostly care
about the upper bound, and, analyze only the upper bound is common easier than
analyze both upper and lower bounds.

#### Exercises

- [x] [1.14](./1.14.md)
- [x] [1.15](./1.15.md)

### 1.2.4 Exponentiation

[`exponent.rkt`](./exponent.rkt)

From footnote 37, the base for the logarithmic process in $\Theta(log(n))$
doesn't matter due to the arbitrary constant $k_1$ and $k_2$. Recall that we can
always convert from $log_a(n)$ to $log_b(n)$ using a constant.

#### Exercises

- [x] [1.16](./1.16.md)
- [x] [1.17](./1.17.md)
- [x] [1.18](./1.18.md)
- [x] [1.19](./1.19.md)

### 1.2.5 Greatest Common Divisors

<details>
  <summary>2020 note</summary>

It's funny when you are working through SICP, and they mention TAOCP, which
you're also working through as the same time. I' choose to work on SICP because
Knuth volume 1 requires too much Math, such that I can't program. And SICP seems
easier to code. Doing both seems a good balance between handwriting mathematics
and programming in a completely new language.

</details>

[Proof of Lamé's Theorem](https://en.wikipedia.org/wiki/Lam%C3%A9%27s_theorem),
quite a clever mapping of Fibonacci to the sequences of numbers generated by by
Euclidean algorithm. Footnote 43 also briefly explain the proof.

#### Exercises

- [x] [1.20](./1.20.md)

### 1.2.6 Example: Testing for Primality

See [proof of Fermat's Little Theorem][fermat-little]

[fermat-little]:
  https://en.wikipedia.org/wiki/Proofs_of_Fermat%27s_little_theorem

**[Probabilistic algorithms][probalgo]**: employ randomness as part of the
logic; output has more chance to be incorrect, runtime might not be finite,
however, for some problems, this is the only practical means to solve. There's 2
types of Probabilistic algorithms (both the names refer to some famous casinos):

- [Las Vegas][lasvegas]: output is always correct, runtime is finite, e.g.
  Quicksort, Quickselect.
- [Monte Carlo][monte]: output might be incorrect.

[probalgo]: https://en.wikipedia.org/wiki/Randomized_algorithm
[lasvegas]: https://en.wikipedia.org/wiki/Las_Vegas_algorithm
[monte]: https://en.wikipedia.org/wiki/Monte_Carlo_algorithm

Footnote 47 (highlighted by me):

> In testing primality..., the chance of stumbling upon a value that fools the
> Fermat test (Carmichael numbers) is less than the chance that cosmic radiation
> will cause the computer to make an error...
>
> (That's) the difference between mathematics and engineering.

#### Exercises

- [x] [1.21](./1.21.md)
- [x] [1.22](./1.22.md)
- [x] [1.23](./1.23.md)
- [x] [1.24](./1.24.md)
- [x] [1.25](./1.25.md)
- [x] [1.26](./1.26.md)
- [x] [1.27](./1.27.md)
- [ ] [1.28](./1.28.md)

## 1.3 Formulating Abstractions with Higher-Order Procedures

### 1.3.1 Procedures as Arguments

### 1.3.2 Constructing Procedures Using Lambda

### 1.3.3 Procedures as General Methods

### 1.3.4 Procedures as Returned Values
