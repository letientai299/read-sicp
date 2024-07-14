# Reading SICP

## About

The [wizard][wiki] book: http://sarabander.github.io/sicp/

[wiki]: https://en.wikipedia.org/wiki/SICP

This repo contains my reading notes and solutions for the exercises.

The notes are mostly snippets, thoughts, summaries... They are intended for me
to quickly revisit the content some years later. They might not be helpful for
you if you haven't read the books.

The solution code is written in Racket, hopefully sufficiently documented and
tested. I aim to learn enough Racket to complete the book, as well as writing
something useful (in the context of this repo) with it.

## Notes and status

- [Intro](./intro.md)
- [Chapter 1](./ch01/readme.md)
- [Chapter 2](./ch02/readme.md)
- Chapter 3: TODO
- Chapter 4: TODO
- Chapter 5: TODO

## Tools

### Core

I use [Racket](https://racket-lang.org) because it seems to have tons of
features and [a dedicated text book](https://htdp.org) which aims to be the
successor of SICP. Beside the standard distribution of Racket, I also use these
packages:

- [`fmt`](https://docs.racket-lang.org/fmt/): to have `raco fmt` for formatting
  racket code.

  This tool supports a configuration file `.fmt.rkt`. However, I don't use it
  because: the config is Racket code, not some typical `ini` or command line
  option lists; the tool doesn't walk up to find the file in git root. Hence, I
  hard code the command line option in my editor to be equivalent to this:

  ```
  raco fmt --limit 60 --width 80
  ```

- [`racket-langserver`](https://github.com/jeapostrophe/racket-langserver): to
  have some editor supports when using vim.
- [`debug`](https://docs.racket-lang.org/debug/index.html): to quickly show the
  expression and its value.

### Helpers

- [nodemon](https://nodemon.io): for running `*rkt` files on save.
- [markserv](https://github.com/markserv/markserv): live review all Markdown
  files in the whole project, supports $\LaTeX$.
- [Violentmonkey](https://violentmonkey.github.io): to quickly copy contents
  from book website into my notes. See [`./sicp.user.js`](./sicp.user.js).

## Racket tips

### Pretty print struct

Use `#:transparent` to make the struct accessible for low-level inspection for
printing, helpful to define named test cases, see [`1.3.rkt`](./ch01/1.3.rkt).

```scheme
(struct args (a b c) #:transparent)
(print (args 1 2 3))
```
