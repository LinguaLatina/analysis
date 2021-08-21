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

# Concordance of lexemes
# Histogram of lexemes