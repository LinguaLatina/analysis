---
title: Labelling forms
layout: page
parent: Building editions
nav_order: 2
---

# Labelling morphological forms


The `tabulae` github repisotory has a two-column file matchng URNs for morphological forms with corresponding human-readable labels.

```scala
import scala.io.Source

val url = "https://raw.githubusercontent.com/neelsmith/tabulae/master/cex/forms.cex"
val data = Source.fromURL(url).getLines.toVector
```


>!WARNING! The current version is just a permutation of all possible values for each morphological property and therefore does not yet exclude impossible combinations such as first-person imperative finite verbs, or perfect active participles.
