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

#### Exercise

- [ ] [2.4](./2.1/2.4.md)
- [ ] [2.5](./2.1/2.5.md)
- [ ] [2.6](./2.1/2.6.md)

### 2.1.4 Extended Exercise: Interval Arithmetic

#### Exercise

- [ ] [2.7](./2.1/2.7.md)
- [ ] [2.8](./2.1/2.8.md)
- [ ] [2.9](./2.1/2.9.md)
- [ ] [2.10](./2.1/2.10.md)
- [ ] [2.11](./2.1/2.11.md)
- [ ] [2.12](./2.1/2.12.md)
- [ ] [2.13](./2.1/2.13.md)
- [ ] [2.14](./2.1/2.14.md)
- [ ] [2.15](./2.1/2.15.md)
- [ ] [2.16](./2.1/2.16.md)

## 2.2 Hierarchical Data and the Closure Property

### 2.2.1 Representing Sequences

### 2.2.2 Hierarchical Structures

### 2.2.3 Sequences as Conventional Interfaces

### 2.2.4 Example: A Picture Language

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
