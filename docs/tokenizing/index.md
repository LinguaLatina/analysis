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
// res0: Vector[String] = Vector(
//   "a",
//   "abisse",
//   "acamas",
//   "achiui",
//   "annos",
//   "aperto",
//   "arbitrati",
//   "arcem",
//   "atque",
//   "capere",
//   "cassandra",
//   "collecti",
//   "cum",
//   "custodes",
//   "danai",
//   "dant",
//   "dato",
//   "decem",
//   "diomedes",
//   "dono",
//   "duci",
//   "edixit",
//   "ei",
//   "epeus",
//   "equo",
//   "equum",
//   "equus",
//   "essent",
//   "est",
//   "et",
//   "ex",
//   "exierunt",
//   "fecit",
//   "fides",
//   "habita",
//   "hostes",
//   "id",
//   "imperauit",
//   "in",
//   "inesse",
//   "ipsi",
//   "lassi",
//   "ligneum",
//   "lusu",
//   "machaon",
//   "magnitudinis",
//   "magno",
//   "menelaus",
// ...
tokenizable.tokenizedCorpus
// res1: Corpus = Corpus(
//   Vector(
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.0"),
//       "EQUUS"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.1"),
//       "TROIANUS"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.title.1_0"),
//       "."
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.0"),
//       "Achiui"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.1"),
//       "cum"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.2"),
//       "per"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.3"),
//       "decem"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.4"),
//       "annos"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.5"),
//       "Troiam"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.6"),
//       "capere"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.7"),
//       "non"
//     ),
//     CitableNode(
//       CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:108a.1.8"),
//       "possent"
// ...
```
