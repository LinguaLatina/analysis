---
title: Build a parsed corpus
layout: page
nav_order: 4
parent: A complete example
---

# Build a parsed corpus

After parsing the word list for a corpus, you can build a new parsed corpus by combining your original citable corpus with the parsing results.


## Load a corpus and corresponding parsing data

The text corpus:
```scala mdoc:silent
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)
val c108a = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```

The parsing data:

```scala mdoc:silent
import scala.io.Source
val fstUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/example/c108-fst.txt"
val fstLines = Source.fromURL(fstUrl).getLines.toVector
```


The combination:

```scala mdoc:silent
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._
val latc = LatinCorpus.fromFstLines(c108a,Latin23Alphabet, fstLines, strict=false)
```

## Save it as CEX

Requires a URN manager:

```scala mdoc:silent
import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/LinguaLatina/morphology/master/urnmanager/config.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)

```
