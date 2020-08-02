---
title: Parse a word list
layout: page
nav_order: 3
parent: A complete example
---

# Parse a word list

You'll used the Stuttgart FST toolkit's `fst-infl` program to run  [the parser you built with `tabulae`](../compile/) (named `latin.a` by default) over your word list. You can save the results in a file by redirecting standard output.  For example, if you saved the [sample word list here}(https://github.com/LinguaLatina/analysis/tree/master/data/example), you could save the parsing results in FST format like this:

```sh
fst-infl latin.a c108-words.txt | tee c108-fst.txt
```
