---
title: Orthography and tokenization
layout: page
nav_order: 2
---


# Orthography and tokenization

- explicitly defined orthographic systems
- classified tokenization

Create a tokenizable corpus:

- a citable corpus
- an orthographic system




Need to import trait as well as implementation:
```scala
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)
```


Two common activities in analyzing a corpus:

1. Generate a word list
2. Create a tokenized corpus:

```scala
tokenizable.wordList
tokenizable.tokenizedCorpus
```
