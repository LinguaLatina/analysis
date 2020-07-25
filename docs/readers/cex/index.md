---
title: Formatting a CEX file
layout: page
parent: Building editions
---


# Formatting a CEX file




See pages on this site for how to build a `LatinCorpus` like this:

```scala
import edu.holycross.shot.latincorpus._
import scala.io.Source
val fstUrl = "https://lingualatina.github.io/analysis/data/c108.fst"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

val lat23orthogaphy: MidOrthography = Latin23Alphabet
val latc = LatinCorpus.fromFstLines(chapter,lat23orthogaphy, fstLines, strict=false)
```

The `LatinCorpus` can generate a CEX-formatted summary of each analysis.

We need to create a `UrnManager` than can expand the abbreviated URNs used in `tabulae`'s output to full URNs.

```scala
import edu.holycross.shot.tabulae._
val abbreviations = Vector(
  "abbr#full",
  s"ls#urn:cite2:tabulae:ls.v1:"
)
val urnManager = UrnManager(abbreviations)
```


With that in hand, we can generate a CEX description for each analysis of each token.

```scala
val cexLines = latc.citeCollectionLines(urnManager)
// cexLines: Vector[String] = Vector(
//   "urn:cite2:linglat:tkns.v1:2020_07_25_0#Record 2020_07_25_0#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.0#EQUUS#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_1#Record 2020_07_25_1#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.1#TROIANUS#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_2#Record 2020_07_25_2#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.1_0#.#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_3#Record 2020_07_25_3#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.0#Achiui#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_4#Record 2020_07_25_4#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.1#cum#urn:cite2:tabulae:ls.v1:n11872#urn:cite2:tabulae:morphforms.v1:00000000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_5#Record 2020_07_25_5#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.2#per#urn:cite2:tabulae:ls.v1:n34595#urn:cite2:tabulae:morphforms.v1:00000000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_6#Record 2020_07_25_6#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.3#decem#urn:cite2:tabulae:ls.v1:n12432#urn:cite2:tabulae:morphforms.v1:00000000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_7#Record 2020_07_25_7#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.4#annos#urn:cite2:tabulae:ls.v1:n2698#urn:cite2:tabulae:morphforms.v1:01000110",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_8#Record 2020_07_25_8#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.4#annos#urn:cite2:tabulae:ls.v1:n2698#urn:cite2:tabulae:morphforms.v1:02000140",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_9#Record 2020_07_25_9#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.5#Troiam#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_10#Record 2020_07_25_10#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.6#capere#urn:cite2:tabulae:ls.v1:n6614#urn:cite2:tabulae:morphforms.v1:21112000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_11#Record 2020_07_25_11#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.6#capere#urn:cite2:tabulae:ls.v1:n6614#urn:cite2:tabulae:morphforms.v1:00101000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_12#Record 2020_07_25_12#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.7#non#urn:cite2:tabulae:ls.v1:n31151#urn:cite2:tabulae:morphforms.v1:00000001",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_13#Record 2020_07_25_13#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.8#possent#urn:cite2:tabulae:ls.v1:n37193#urn:cite2:tabulae:morphforms.v1:32221000",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_14#Record 2020_07_25_14#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.8_0#,#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
//   "urn:cite2:linglat:tkns.v1:2020_07_25_15#Record 2020_07_25_15#urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.9#Epeus#urn:cite2:tabulae:ls.v1:null#urn:cite2:tabulae:morphforms.v1:null",
// ...
```


Write the results to a local file if you like:

```scala
import java.io.PrintWriter
val header = "#!ctsdata\nurn#label#passage#text#lexeme#form\n"
// header: String = """#!ctsdata
// urn#label#passage#text#lexeme#form
// """
new PrintWriter("token-analyses.cex"){
  write(header + cexLines.mkString("\n")); close;}
// res0: PrintWriter = repl.Session$App$$anon$1@35c78fdf
```
