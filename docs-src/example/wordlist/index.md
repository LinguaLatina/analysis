---
title: Make a word list
layout: page
nav_order: 1
parent: A complete example
---

# Build a word list for your corpus

Load a citable corpus.

```scala mdoc:silent
import edu.holycross.shot.ohco2._
import edu.holycross.shot.mid.orthography._
// Load citable corpus
val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
// tiny subset to practice on
import edu.holycross.shot.cite._
val c108a = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```


To tokenize, we need to import the `MidOrthography` trait, and an implementation for our corpus.

```scala mdoc:silent
import edu.holycross.shot.mid.orthography.MidOrthography
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(c108a, Latin23Alphabet)
val wordList = tokenizable.wordList
// write to a file
import java.io.PrintWriter
new PrintWriter("c108-words.txt"){write(wordList.mkString("\n"));close;}
```
