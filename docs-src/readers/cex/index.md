---
title: Formatting a CEX file
layout: page
parent: Building editions
---


# Formatting a CEX file


See pages on this site for how to build a `LatinCorpus` using data accessible from URLs like this:


```scala mdoc:silent
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


```scala mdoc:silent
import edu.holycross.shot.latincorpus._
import scala.io.Source
val fstUrl = "https://lingualatina.github.io/analysis/data/c108.fst"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

val lat23orthogaphy: MidOrthography = Latin23Alphabet
val latc = LatinCorpus.fromFstLines(chapter,lat23orthogaphy, fstLines, strict=false)
```

The `LatinCorpus` can generate a CEX-formatted summary of each analysis.

We need to create a `UrnManager` than can expand the abbreviated URNs used in `tabulae`'s output to full URNs.

```scala mdoc:silent
import edu.holycross.shot.tabulae._
val abbreviations = Vector(
  "abbr#full",
  "ls#urn:cite2:tabulae:ls.v1:"
)
val urnManager = UrnManager(abbreviations)
```


With that in hand, we can generate a CEX description for each analysis of each token.

```scala mdoc
val cexLines = latc.citeCollectionLines(urnManager)
```


Write the results to a local file if you like:

```scala mdoc:silent
import java.io.PrintWriter
val header = "#!ctsdata\nurn#label#passage#text#lexeme#form\n"
new PrintWriter("token-analyses.cex"){
  write(header + cexLines.mkString("\n")); close;}
```
