---
title: Citable texts
layout: page
nav_order: 1
---


## Working with citable texts


- load a citable corpus  from a URL
- use URN notation to select a new corpus


```scala mdoc:silent
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")
```
