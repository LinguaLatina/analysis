# Work with precooked analyses of tokens to compute
# frequencies of lexemes.
using CitableText
using CitableCorpus
using LatinOrthography, Orthography
using DataFrames
using CSV
using HTTP
using StatsBase

# Morphologicall parse of lexical items
morphurl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/pluto/pluto-token-analyses.cex"
# raw dataframe of data set
tknanalysesdf = CSV.File(HTTP.get(morphurl).body) |> DataFrame
lexicalanalyses = filter(row -> row[:category] == "LexicalToken", tknanalysesdf)
analyzedtokens = filter(row -> row[:lexeme] != "ls.null", lexicalanalyses)

# pairings of lexemes and tokens
lexemesByToken = begin
    newurns = []
	newlexemes = []
	pairs = []
	for row in eachrow(analyzedtokens)
		push!(newurns, row[:urn])
		push!(newlexemes, row[:lexeme])
	end
	df = DataFrame(urn = newurns, lexeme = newlexemes)
	unique!(df)
end

lexcounts = begin 
	lexmap = countmap(lexemesByToken[:,:lexeme])
	sort(collect(lexmap), by=pr->pr[2], rev=true)
end

selected = filter(r -> startswith(r.urn, "urn:cts:latinLit:stoa1263.stoa001.hc_tkns:30pr") || startswith(r.urn, "urn:cts:latinLit:stoa1263.stoa001.hc_tkns:31pr"),  lexemesByToken)


selectedcounts = begin 
	sellexmap = countmap(selected[:,:lexeme])
	sort(collect(sellexmap), by=pr->pr[2], rev=true)
end

# Text has > 4K distinct tokens.
# Max rank we would ever want for unglossed vocab?
# 10% ?
# global rank?
thresh = 300
totaltokens = 4000
corevocab = []
rarevocab = []
for pr in selectedcounts
    idx = findall(lex -> lex.first == pr.first, lexcounts)
    globalpct = pctrank(idx[1], totaltokens)
    idx[1] < thresh ? println("CORE ", pr.first, " rank ", idx[1]," at pct ", globalpct) : println("\tRare ", pr.first, " ", idx[1], " ", globalpct)
    
    idx[1] < thresh ? push!(corevocab, pr.first) : push!(rarevocab, pr.first)
end

function pctrank(rnk, total)
    round(100.0 * rnk / total; digits=2)
end

# Concordance of lexemes
# Histogram of lexemes