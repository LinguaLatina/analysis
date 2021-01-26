### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f9075e6c-5fd8-11eb-198f-354c922bfd61
# Set up environment
begin
	using Pkg
	Pkg.activate(".")
	Pkg.add("CitableText")
	Pkg.add("CSV")
	Pkg.add("DataFrames")
	#Pkg.add("FreqTables")
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("StatsBase")
		
	
	using CitableText
	using CSV
	using DataFrames
	#using FreqTables
	using Plots
	using StatsBase
	
	using PlutoUI
end

# ╔═╡ 02e34e8c-5fd9-11eb-1306-6309a87a36bd
md"Define environment in hidden cell."

# ╔═╡ dfb69194-5fd8-11eb-2bad-e7e6201ff5aa
md"## Vocabulary in Hyginus, take 2"

# ╔═╡ 6aa1f1f0-6021-11eb-16b5-2b4910b3683d
md"Size of image: $(@bind w Slider(300:1000, show_value=false))"

# ╔═╡ a3e6cf7a-6010-11eb-0ffb-316b3fe61315
md"> Graphing coverage"

# ╔═╡ 54d1e082-5fd9-11eb-233b-39f68c5cbbc6
md"> Compute overview of Hyginus"

# ╔═╡ af9e0874-6017-11eb-101f-9bc1126a3314
md"> What-if functions"

# ╔═╡ 4713512e-5fd9-11eb-06d6-2ba2419c6252
md"> ### Loading data"

# ╔═╡ 58134b9c-5fe5-11eb-35a0-cf70533dda53
tknanalysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ 6c9033b6-5fe5-11eb-3a26-03358ad850bd
# raw dataframe of data set
tknanalysesdf = CSV.File(tknanalysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 5eb787e6-5fd9-11eb-3fc3-81912954efb6
numlexemes = length(unique(tknanalysesdf[:, :lexeme])) - 1

# ╔═╡ d5cc52f8-6010-11eb-0233-e9f98aec288d
md"Size of vocabulary: $(@bind vocabsize Slider(100:numlexemes, show_value=true))"

# ╔═╡ b2ec0d80-6010-11eb-0f05-b9b38f4bdb8a
xs = 1:numlexemes

# ╔═╡ e9d941a0-6017-11eb-350d-3962d89be793
md"> ### Organizing data for analysis"

# ╔═╡ 2522b228-6018-11eb-0c66-cd36f707429d
md"""**Isolate:**

- *lexical analyses*
- *non-null lexical analyses*
- *analyses of lexemes limited to one occurrence per token*

"""

# ╔═╡ fb585532-6018-11eb-02d4-035f1942acef
md"All analyses identified as a `LexicalToken`"

# ╔═╡ c563f48c-5ff4-11eb-2a2f-c5a6ee001fd2
lexicalanalyses = filter(row -> row[:category] == "LexicalToken", tknanalysesdf)

# ╔═╡ 9c23719c-5ff4-11eb-0be1-4d2231ad9135
numlexicaltokens = length(unique(lexicalanalyses[:,:urn]))

# ╔═╡ 8b3f7954-6001-11eb-176b-2d5282839751
# Percentage of all lexical tokens represented by a given number of tokens
function pctOfLexicalTokens(n, precision=1)
	round(100.0 * n / numlexicaltokens, digits=precision)
end

# ╔═╡ 13e50672-6019-11eb-1360-dd915bf2002f
md"Non-null analyses of lexical tokens"

# ╔═╡ 374aeeac-5ff5-11eb-3ccd-b31b5d4e75f0

analyzedtokens = filter(row -> row[:lexeme] != "ls.null", lexicalanalyses)

# ╔═╡ 19d99d74-6000-11eb-14e0-b9d53da4d309
numanalyzedforms = length(unique(map(s -> lowercase(s), analyzedtokens[:,:token])))

# ╔═╡ b50c319a-5fda-11eb-20b9-bdfecd7bf342
numtokenanalyses = length(analyzedtokens[:, :urn])

# ╔═╡ 5189e0a4-5fda-11eb-3f9a-55915798af41
numanalyzedtokens = length(unique(analyzedtokens[:,:urn]))

# ╔═╡ a76957c6-6001-11eb-013e-c99f340b3b95
pctanalyzed =	pctOfLexicalTokens(numanalyzedtokens, 1)

# ╔═╡ 88fea86e-6019-11eb-13e2-634b850d2c06
md"Occurrences of lexemes limited to one occurence per token"

# ╔═╡ a90a5218-6012-11eb-1bbc-ef76665e113b
# List of lexemes limited to 1 occurence per token
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

# ╔═╡ 9c6269f2-6016-11eb-1480-31942b1427bd
numpossiblelexemes = nrow(lexemesByToken)

# ╔═╡ ea7b3b26-601f-11eb-21a5-0f8b5d2d10d2
# Percentage of all lexical tokens represented by a given number of tokens
function pctPossibleLexemes(n, precision=1)
	doublecounts = numpossiblelexemes - numanalyzedtokens
	round(100.0 * n / (numlexicaltokens + doublecounts), digits=precision)
end

# ╔═╡ 953e8df6-6005-11eb-0afb-5bc35be589b8
md">Counting frequencies of lexemes"

# ╔═╡ a43d6b42-6019-11eb-05ba-f978fdc32582
md"Sorted counts of all possible occurrences of lexemes"

# ╔═╡ 641c6d98-6004-11eb-310f-2777b799f823
# Count the number of instances where a given lexeme could occur.
# Note that in lexemeByToken, if a single lexeme could support multiple IDs 
# for the same token, it is only  counted once. 
# If more than one lexeme could support an ID for the same token,
# each is counted.  
# The total of these counts will therefore be greater than the number of tokens.
lexcounts = begin 
	lexmap = countmap(lexemesByToken[:,:lexeme])
	sort(collect(lexmap), by=pr->pr[2], rev=true)
end

# ╔═╡ 15bda764-601a-11eb-2867-ddbce7a2d57a
md"Cumulative totals for counts in `lexcounts`"

# ╔═╡ 1205cd98-6012-11eb-005b-a5f9051fef9a
# Cumuluative totals of occurences of lexemes
runningtotals = begin
	counts = map(pr -> pr[2], lexcounts)
	cumsum(counts)
end

# ╔═╡ 829df2f8-601f-11eb-2c80-7d6d5cec6423
# Coverage of a given number of vocab items
function coverage(n)
	tokencount = runningtotals[n]
	pctPossibleLexemes(tokencount)
end

# ╔═╡ dc57ce5e-6010-11eb-3f8d-416724626481
md"""

| Vocabulary size | Tokens recognized | Percent of tokens in Hyginus | 
| --- | --- | --- |
| **$(vocabsize)** | $(runningtotals[vocabsize]) | **$(coverage)%** |

"""





# ╔═╡ bd529052-6010-11eb-3fb5-9bfd390f722d
ys = begin
	#	map(le -> convert(Int64, round(100 * (countForVocab(le)  / numlexicaltokens))) , Vector(xs))
		
		#tokencount = runningtotals[vocabsize]
	#pctPossibleLexemes(tokencount)
	map(le -> coverage(le), Vector(xs))
end

# ╔═╡ 949a3fc0-6010-11eb-1ace-d151b0a1427a
begin
	plotly()
	plot(xs, ys, legend=false, xlabel="Vocabulary items", ylabel="Percent covered", size=(w,w), title="Pct coverage for vocab. size")
end

# ╔═╡ 31eced9e-601a-11eb-12ba-e7c6477efd1b
md">Counting frequencies of forms"

# ╔═╡ 79242f72-6005-11eb-1226-d59e8a6ba865
formcounts = begin
	formsmap = countmap(analyzedtokens[:,:token])
	sort(collect(formsmap), by=pr->pr[2], rev=true)
end

# ╔═╡ b50c952e-6005-11eb-16f6-e7fa560adf7a
singletons = length(filter(pr -> pr[2] == 1, formcounts))

# ╔═╡ 6c915066-5ff4-11eb-30ce-7b604d2dec6b
md"""
**Overview**

| Feature | Count | 
| --- | --- | 
| "Words" in text (lexical tokens) | **$(numlexicaltokens)** |
| Distinct word forms | **$(numanalyzedforms)** |
| Forms appearing only once | **$(singletons)** |
| Parsed tokens | **$(numanalyzedtokens)** |
| Percent of words parsed | **$(pctanalyzed)** |
| "Vocabulary items" (lexemes) | **$(numlexemes)** |
| Possible lexemes in parsed tokens | **$(numpossiblelexemes)** |


"""

# ╔═╡ Cell order:
# ╟─02e34e8c-5fd9-11eb-1306-6309a87a36bd
# ╟─f9075e6c-5fd8-11eb-198f-354c922bfd61
# ╟─dfb69194-5fd8-11eb-2bad-e7e6201ff5aa
# ╟─6c915066-5ff4-11eb-30ce-7b604d2dec6b
# ╟─d5cc52f8-6010-11eb-0233-e9f98aec288d
# ╟─dc57ce5e-6010-11eb-3f8d-416724626481
# ╟─949a3fc0-6010-11eb-1ace-d151b0a1427a
# ╟─6aa1f1f0-6021-11eb-16b5-2b4910b3683d
# ╟─a3e6cf7a-6010-11eb-0ffb-316b3fe61315
# ╠═b2ec0d80-6010-11eb-0f05-b9b38f4bdb8a
# ╠═bd529052-6010-11eb-3fb5-9bfd390f722d
# ╟─54d1e082-5fd9-11eb-233b-39f68c5cbbc6
# ╟─5eb787e6-5fd9-11eb-3fc3-81912954efb6
# ╟─9c23719c-5ff4-11eb-0be1-4d2231ad9135
# ╟─19d99d74-6000-11eb-14e0-b9d53da4d309
# ╟─b50c319a-5fda-11eb-20b9-bdfecd7bf342
# ╟─5189e0a4-5fda-11eb-3f9a-55915798af41
# ╟─9c6269f2-6016-11eb-1480-31942b1427bd
# ╟─a76957c6-6001-11eb-013e-c99f340b3b95
# ╟─b50c952e-6005-11eb-16f6-e7fa560adf7a
# ╟─af9e0874-6017-11eb-101f-9bc1126a3314
# ╟─8b3f7954-6001-11eb-176b-2d5282839751
# ╟─ea7b3b26-601f-11eb-21a5-0f8b5d2d10d2
# ╠═829df2f8-601f-11eb-2c80-7d6d5cec6423
# ╟─4713512e-5fd9-11eb-06d6-2ba2419c6252
# ╟─58134b9c-5fe5-11eb-35a0-cf70533dda53
# ╟─6c9033b6-5fe5-11eb-3a26-03358ad850bd
# ╟─e9d941a0-6017-11eb-350d-3962d89be793
# ╟─2522b228-6018-11eb-0c66-cd36f707429d
# ╟─fb585532-6018-11eb-02d4-035f1942acef
# ╠═c563f48c-5ff4-11eb-2a2f-c5a6ee001fd2
# ╟─13e50672-6019-11eb-1360-dd915bf2002f
# ╠═374aeeac-5ff5-11eb-3ccd-b31b5d4e75f0
# ╟─88fea86e-6019-11eb-13e2-634b850d2c06
# ╟─a90a5218-6012-11eb-1bbc-ef76665e113b
# ╟─953e8df6-6005-11eb-0afb-5bc35be589b8
# ╟─a43d6b42-6019-11eb-05ba-f978fdc32582
# ╟─641c6d98-6004-11eb-310f-2777b799f823
# ╟─15bda764-601a-11eb-2867-ddbce7a2d57a
# ╟─1205cd98-6012-11eb-005b-a5f9051fef9a
# ╟─31eced9e-601a-11eb-12ba-e7c6477efd1b
# ╟─79242f72-6005-11eb-1226-d59e8a6ba865
