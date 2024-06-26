# Reading SICP

## About

The book: http://sarabander.github.io/sicp/

This repo contains my reading notes and solutions for the excersices.

The notes are mostly snippsets, thoughts, summaries... They are intended for me
to quickly revisit the content some years later. They might not be helpful for
you if you haven't read the books.

The solution code is written in Racket, hopefully sufficiently documented and
tested. I aim to learn enough Racket to complete the book, as well as writing
something useful (in the context of this repo) with it.

## Tools

[Racket](https://racket-lang.org), with followin packages:

- [`fmt`](https://docs.racket-lang.org/fmt/): to have `raco fmt` for formatting
  racket code.
- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver): to
  have some editor supports when using Vim/VsCode.

## Notes and status

- [Chapter 1](./ch01/readme.md)

## Racket tips

### Pretty print struct

Use `#:transparent` to make the struct accessible for low-level inspection for
printing, helpful to define named test cases, see [`1.3.rkt`](./ch01/1.3.rkt).

```racket
(struct args (a b c) #:transparent)
(print (args 1 2 3))
```
