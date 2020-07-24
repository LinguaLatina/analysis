---
title: Morphological data
layout: page
nav_order: 3
---


# Working with morphological analyses

```scala mdoc:invisible
// From citable corpus page:
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```

```scala mdoc:silent
// From orthography and tokenizing page:
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)
```
