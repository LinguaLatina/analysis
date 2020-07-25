---
title: Formatting a CEX file
layout: page
parent: Building editions
---


# Formatting a CEX file


```scala mdoc:invisible
// From citable corpus page:
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```

```scala mdoc:invisible
// From orthography and tokenizing page:
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)
```

See how to build a `LatinCorpus`.

```scala mdoc:silent
import edu.holycross.shot.latincorpus._
import scala.io.Source
val fstUrl = "https://lingualatina.github.io/analysis/data/c108.fst"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

val lat23orthogaphy: MidOrthography = Latin23Alphabet
val latc = LatinCorpus.fromFstLines(chapter,lat23orthogaphy, fstLines, strict=false)
```

Then cycle through its tokens, and for each token, cycle through its analyses.
