# analysis

Libraries and utility scripts for analyzing texts.

See documentation at <https://lingualatina.github.io/analysis/>.  All code included on those pages is working code executed and tested using [`mdoc`](https://github.com/scalameta/mdoc).  Note that if you wish to build the documentation from scratch, you will need an installation of the [`tabulae`](https://github.com/neelsmith/tabulae) system, and [the Lingua Latina morphogical datasets](https://github.com/lingualatina/morphology/).


## Sample cycle

Outside of this repository:

- Full text editions are curated in the L3 `texts` repository
- Build parsers in the L3 `morphology` repository


Then, in this repository:

- If text editions have been updated:
    - optionally, generate a new subset-edition (e.g., selections from Pliny in Shelton: `subsetcorpu.sc` in scripts directory)
    - make a `TokenizableCorpus` and generate a wordlist.  (In scripts directory, `[pliny|hyginus]WordList.sc`.) Save the results to `data/[pliny|hyginus]/[pliny|hyginus]-wordlist.txt`.

- If text editions *or* morphological parser has been updated:
    - parse the word list (`fst-infl PARSER data/[pliny|hyginus]/[pliny|hyginus]-wordlist.txt | tee data/[pliny|hyginus]/[pliny|hyginus]-fst.txt`)
    - build a `LatinCorpus` from the FST output. (In scripts directory, `update[Pliny|Hyginus].sc`)
    - analyze a histogram of failed analyses (In scripts directory, `reviewVocab.sc`)
