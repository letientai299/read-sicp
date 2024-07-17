# 2. Building Abstractions with Data

<!-- toc -->

- [2.1 Introduction to Data Abstraction](#21-introduction-to-data-abstraction)
  - [2.1.1 Example: Arithmetic Operations for Rational Numbers](#211-example-arithmetic-operations-for-rational-numbers)
  - [2.1.2 Abstraction Barriers](#212-abstraction-barriers)
  - [2.1.3 What Is Meant by Data?](#213-what-is-meant-by-data)
  - [2.1.4 Extended Exercise: Interval Arithmetic](#214-extended-exercise-interval-arithmetic)
- [2.2 Hierarchical Data and the Closure Property](#22-hierarchical-data-and-the-closure-property)
  - [2.2.1 Representing Sequences](#221-representing-sequences)
  - [2.2.2 Hierarchical Structures](#222-hierarchical-structures)
  - [2.2.3 Sequences as Conventional Interfaces](#223-sequences-as-conventional-interfaces)
  - [2.2.4 Example: A Picture Language](#224-example-a-picture-language)
- [2.3 Symbolic Data](#23-symbolic-data)
  - [2.3.1 Quotation](#231-quotation)
  - [2.3.2 Example: Symbolic Differentiation](#232-example-symbolic-differentiation)
  - [2.3.3 Example: Representing Sets](#233-example-representing-sets)
  - [2.3.4 Example: Huffman Encoding Trees](#234-example-huffman-encoding-trees)
- [2.4 Multiple Representations for Abstract Data](#24-multiple-representations-for-abstract-data)
  - [2.4.1 Representations for Complex Numbers](#241-representations-for-complex-numbers)
  - [2.4.2 Tagged data](#242-tagged-data)
  - [2.4.3 Data-Directed Programming and Additivity](#243-data-directed-programming-and-additivity)
- [2.5 Systems with Generic Operations](#25-systems-with-generic-operations)
  - [2.5.1 Generic Arithmetic Operations](#251-generic-arithmetic-operations)
  - [2.5.2 Combining Data of Different Types](#252-combining-data-of-different-types)
  - [2.5.3 Example: Symbolic Algebra](#253-example-symbolic-algebra)

<!-- tocstop -->

https://sarabander.github.io/sicp/html/Chapter-2.xhtml

What to expect in this chaper:

- Abtraction as a technique for coping with complexity. Data Abtraction enable
  _abstraction barriers_ between different parts of a program.
- Kinds of "glue" to combine data:
  - Procedure.
  - _Closure_
- Compound data objects can serve as _convetional itnerfaces_ for modularity.
- _Symbolic expressions_: data whose elementary parts can be arbitrary
  _symbols_. Example:
  - Symbolic differentiation
  - Sets representation
  - Information encoding
- _Generic operations_
- _Data directed programming_
- Math: symbol arithmetic on polynomials, support integer, rational, complex and
  other polynomials.

> TODO (tai): revisit the note for chapter 2
>
> - What is data directed programming in modern terms?

## 2.1 Introduction to Data Abstraction

https://sarabander.github.io/sicp/html/2_002e1.xhtml#Example_003a-Arithmetic-Operations-for-Rational-Numbers

**Data abstraction**: methodology, isolate how a object is used from the details
of how it is constructed. Basically, it's the **Encapsulation** in OOP.

These concepts remind me of OOP. I know that we will get these in chapter 3. I
just don't think we will hit them here, as I expect this chapter is more about
standard data structure.

- _Constructors_: implement concrete data representation
- _Selectors_: implement data accessing that allow other "programs" use it.

### 2.1.1 Example: Arithmetic Operations for Rational Numbers

https://sarabander.github.io/sicp/html/2_002e1.xhtml#Example_003a-Arithmetic-Operations-for-Rational-Numbers

**Wishful thinking**, as my understanding, is to think about what can be done
before consider how to satisfy the preconditions.

**[Pairs](https://sarabander.github.io/sicp/html/2_002e1.xhtml#Pairs)**

- `cons`: stand for "construct".
- `car`: "Contents of Address part of Register" (historical reason)
- `cdr`: "Contents of Decrement part of Register" (historical reason)

I can already see how "list" and "tree" can be implemented using `cons`.

```scheme
              head
              |
list := (cons val (cons ...))
                   |
                   tail
tree := (cons val (cons (cons ...) (cons ...)))
                         |          |
                         left       right
```

- List-structured data: objects constructed from pairs (Lisp is List Procesing)

#### Exercise

- [x] [2.1](./2.1/2.1.md)

### 2.1.2 Abstraction Barriers

https://sarabander.github.io/sicp/html/2_002e1.xhtml#Abstraction-Barriers

> Constraining ... to a few interface procedures helps us design programs as
> well as modify them, ... allows us to maintain the flexibility to consider
> alternate implementations,... gives us a way to defer that decision without
> losing the ability to make progress on the rest of the system.

#### Exercise

- [x] [2.2](./2.1/2.2.md)
- [x] [2.3](./2.1/2.3.md)

### 2.1.3 What Is Meant by Data?

https://sarabander.github.io/sicp/html/2_002e1.xhtml#What-Is-Meant-by-Data_003f

The idea (highlighted by me):

> Think of data as defined by **some collection of selectors and constructors**,
> together with **specified conditions** that these procedures must fulfill in
> order to be a valid representation.

I was surprise when reading the next paragraph:

> We could implement `cons`, `car`, and `cdr` without using any data structures
> at all but only using procedures.

My attempt to design those procedures before reading the book's solution, with
only those knowledge provided by the book at this point.

<details >
  <summary>Challenge yourself. Think about it first!</summary>

```scheme
; must store x y some where. x and y need not to be primitive.
; what we know:
; - primitive, procedure
; - procedure is also data
; - lambda
; Then, the trick is to use lambda, keep x and y in a closure.
(define (cons x y)
  (lambda (want-x?) (if want-x? x y)))

(define (car pair) (pair #true))
(define (cdr pair) (pair #false))
```

</details>

It's cool! The foundation of all data structure, _a pair_, could be implemented
without any low level concepts like array, memory address. Now, it would be
mind-blowing if `lambda` itselt can be defined using only concepts introduced
before it. But I guess that is not possible. We can't really escape the physics
of hardware.

> The ability to manipulate procedures as objects automatically provides the
> ability to represent compound data.

**Message passing**: procedural representations of data

#### Exercise

- [x] [2.4](./2.1/2.4.md): another mind-blowing way to immplement `cons`, `car`,
      `cdr`, of course, with even less efficient.
- [x] [2.5](./2.1/2.5.md)
- [x] [2.6](./2.1/2.6.md): first encounter with $\lambda$-calculus.

### 2.1.4 Extended Exercise: Interval Arithmetic

https://sarabander.github.io/sicp/html/2_002e1.xhtml#Extended-Exercise_003a-Interval-Arithmetic

I don't understand why the `div-interval` was defined that way, until I read
[Interval arithmetic][interval-arithmetic]

[interval-arithmetic]: https://en.wikipedia.org/wiki/Interval_arithmetic

> A binary operation $*$ on two intervals ... (creates) the set of all possible
> value of $x*y$, where $x$ and $y$ are in their corresponding intervals.

#### Exercise

- [x] [2.7](./2.1/2.7.md)
- [x] [2.8](./2.1/2.8.md)
- [x] [2.9](./2.1/2.9.md)
- [x] [2.10](./2.1/2.10.md)
- [x] [2.11](./2.1/2.11.md)
- [x] [2.12](./2.1/2.12.md)
- [x] [2.13](./2.1/2.13.md)

These 3 exercises strongly emphasize the important of fully understand what our
expressions mean, because (from ex 2.16)

> (seemingly) equivalent algebraic expressions may lead to different answers

- [x] [2.14](./2.1/2.14.md)
- [x] [2.15](./2.1/2.15.md)
- [x] [2.16](./2.1/2.16.md)

## 2.2 Hierarchical Data and the Closure Property

https://sarabander.github.io/sicp/html/2_002e2.xhtml#Hierarchical-Data-and-the-Closure-Property

**Closure property**:

- An operation for _combining_ data objects satisfies the closure property if
  the results can themselves be combined using the same operation.
- The term _closure_ here come from abstract algebra, not to be confused with
  the concept of [function closure][fn-closure]: inner function that can use
  outer function variables.

[fn-closure]: https://en.wikipedia.org/wiki/Closure_(computer_programming)

### 2.2.1 Representing Sequences

https://sarabander.github.io/sicp/html/2_002e2.xhtml#Representing-Sequences

#### Exercises

List operations

- [x] [2.17](./2.2/2.17.md)
- [x] [2.18](./2.2/2.18.md)
- [x] [2.19](./2.2/2.19.md)
- [x] [2.20](./2.2/2.20.md)

Mapping over lists

- [x] [2.21](./2.2/2.21.md)
- [x] [2.22](./2.2/2.22.md)
- [x] [2.23](./2.2/2.23.md)

### 2.2.2 Hierarchical Structures

https://sarabander.github.io/sicp/html/2_002e2.xhtml#Hierarchical-Structures

#### Exercises

- [x] [2.24](./2.2/2.24.md)
- [x] [2.25](./2.2/2.25.md)
- [x] [2.26](./2.2/2.26.md)
- [x] [2.27](./2.2/2.27.md)
- [x] [2.28](./2.2/2.28.md)
- [x] [2.29](./2.2/2.29.md)

[Mapping over trees][map-tree]

[map-tree]:
  https://sarabander.github.io/sicp/html/2_002e2.xhtml#Mapping-over-trees

- [x] [2.30](./2.2/2.30.md)
- [x] [2.31](./2.2/2.31.md)
- [x] [2.32](./2.2/2.32.md)

### 2.2.3 Sequences as Conventional Interfaces

https://sarabander.github.io/sicp/html/2_002e2.xhtml#Sequences-as-Conventional-Interfaces

> ... make the signal-flow structure manifest in the procedures we write, ...
> would increase the conceptual clarity.

#### Exercise

[Sequence Operations](https://sarabander.github.io/sicp/html/2_002e2.xhtml#Sequence-Operations)

- [x] [2.33](./2.2/2.33.md)
- [x] [2.34](./2.2/2.34.md)
- [x] [2.35](./2.2/2.35.md)
- [x] [2.36](./2.2/2.36.md)
- [x] [2.37](./2.2/2.37.md)
- [x] [2.38](./2.2/2.38.md)
- [x] [2.39](./2.2/2.39.md)

[Nested Mappings](https://sarabander.github.io/sicp/html/2_002e2.xhtml#Nested-Mappings)

This part introduces `flatmap` (mapping and flattening/appending result list),
hints about a strategy to process infinite sequence. The book seems to focus on
forming strategy with reusable pieces rather than efficient algorithms.

From now on, to keep my solution code file clean, I'll use more Racket built-in
functions (e.g. `foldr`, `foldl`, `map`, `flatten`, `apply`, ...) instead of
those provided by the book.

- [x] [2.40](./2.2/2.40.md)
- [x] [2.41](./2.2/2.41.md)
- [x] [2.42](./2.2/2.42.md)
- [ ] [2.43](./2.2/2.43.md)

### 2.2.4 Example: A Picture Language

https://sarabander.github.io/sicp/html/2_002e2.xhtml#Example_003a-A-Picture-Language

> a rational-number representation could be anything at all that satisfies an
> appropriate condition...
>
> Painters are our second example of a procedural representation for data.

**Stratified design**:

- A complex system should be structured as a sequence of levels that are
  described using a sequence of languages
- Each level is constructed by combining parts that are regarded as primitive at
  that level.
- The language used at each level of a stratified design has primitives, means
  of combination, and means of abstraction appropriate to that level of detail.

#### Exercises

- [x] [2.44](./2.2/2.44.md)
- [x] [2.45](./2.2/2.45.md)
- [x] [2.46](./2.2/2.46.md)
- [x] [2.47](./2.2/2.47.md)
- [x] [2.48](./2.2/2.48.md)
- [x] [2.49](./2.2/2.49.md)
- [x] [2.50](./2.2/2.50.md)
- [x] [2.51](./2.2/2.51.md)
- [x] [2.52](./2.2/2.52.md)

## 2.3 Symbolic Data

### 2.3.1 Quotation

### 2.3.2 Example: Symbolic Differentiation

### 2.3.3 Example: Representing Sets

### 2.3.4 Example: Huffman Encoding Trees

## 2.4 Multiple Representations for Abstract Data

### 2.4.1 Representations for Complex Numbers

### 2.4.2 Tagged data

### 2.4.3 Data-Directed Programming and Additivity

## 2.5 Systems with Generic Operations

### 2.5.1 Generic Arithmetic Operations

### 2.5.2 Combining Data of Different Types

### 2.5.3 Example: Symbolic Algebra
