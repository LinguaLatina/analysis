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


```scala mdoc:invisible
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```


Need to import trait as well as implementation:
```scala mdoc:silent
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)
```


Two common activities in analyzing a corpus:

1. Generate a word list
2. Create a tokenized corpus:

```scala mdoc
tokenizable.wordList
tokenizable.tokenizedCorpus
```
