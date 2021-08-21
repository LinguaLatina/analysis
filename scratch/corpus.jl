# Work from a raw text corpus to compute token usage
using CitableText
using CitableCorpus
using LatinOrthography, Orthography


url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"

c = CitableCorpus.fromurl(CitableTextCorpus, url)

c30urn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:30pr")
c31urn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:31pr")

c30 = filter(cn -> urncontains(c30urn, cn.urn), c.corpus) |> CitableTextCorpus
c31 = filter(cn -> urncontains(c31urn, cn.urn), c.corpus) |> CitableTextCorpus

# orthography with tokenizer
selection = combine(c30, c31)
tkns = tokenize(latin23(), selection)
alltkns = tokenize(latin23(), c)

# Concordance of lexical tokens
# Histogram of lexical tokens
lexsel = filter(pr -> pr[2] == LexicalToken(), tkns)
lcsel = map( pr -> lowercase(pr[1].text), lexsel)

lex = filter(pr -> pr[2] == LexicalToken(), alltkns)
lcwords =  map( pr -> lowercase(pr[1].text), lex)

