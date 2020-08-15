# analysis

Libraries and utility scripts for analyzing texts.

See documentation at <https://lingualatina.github.io/analysis/>.  All code included on those pages is working code executed and tested using [`mdoc`](https://github.com/scalameta/mdoc).  Note that if you wish to build the documentation from scratch, you will need an installation of the [`tabulae`](https://github.com/neelsmith/tabulae) system, and [the Lingua Latina morphogical datasets](https://github.com/lingualatina/morphology/).


## Sample cycle

Outside of this repository:

- Text editions are curated in the L3 `texts` repository
- Buildd parsers in the L3 `morphology` repository

Then, in this repository:

- make a `TokenizableCorpus` and generate a wordlist.
- parse the word list
- build a `LatinCorpus` from the FST output
- analyze a histogram of failed analyses
