using CitableText
using CitableCorpus
using LatinOrthography, Orthography

url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"

c = CitableCorpus.fromurl(CitableTextCorpus, url)

c30urn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:pr.30")
c31urn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:pr.31")

c30 = filter(cn -> urncontains(c30urn, cn.urn), c.corpus)
c31 = filter(cn -> urncontains(c31urn, cn.urn), c.corpus)

# orthography with tokenizer
selection = CitableTextCorpus([c30, c31])
tkns = tokenize(latin23(), selection)

# Concordance of lexical items
# Histogram of lexical items