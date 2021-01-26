### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

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
md"Vocabulary in Hyginus, take 2"

# ╔═╡ 54d1e082-5fd9-11eb-233b-39f68c5cbbc6
md"> Compute overview of Hyginus"

# ╔═╡ 953e8df6-6005-11eb-0afb-5bc35be589b8
md">Counting frequencies"

# ╔═╡ 4713512e-5fd9-11eb-06d6-2ba2419c6252
md"> Loading and filtering data"

# ╔═╡ 58134b9c-5fe5-11eb-35a0-cf70533dda53
tknanalysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ 6c9033b6-5fe5-11eb-3a26-03358ad850bd
tknanalysesdf = CSV.File(tknanalysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 5eb787e6-5fd9-11eb-3fc3-81912954efb6
numlexemes = length(unique(tknanalysesdf[:, :lexeme]))

# ╔═╡ c563f48c-5ff4-11eb-2a2f-c5a6ee001fd2
lexicalanalyses = filter(row -> row[:category] == "LexicalToken", tknanalysesdf)

# ╔═╡ 9c23719c-5ff4-11eb-0be1-4d2231ad9135
numlexicaltokens = length(unique(lexicalanalyses[:,:urn]))

# ╔═╡ 8b3f7954-6001-11eb-176b-2d5282839751
function pctOfTokens(n, precision=1)
	round(100.0 * n / numlexicaltokens, digits=precision)
end

# ╔═╡ 374aeeac-5ff5-11eb-3ccd-b31b5d4e75f0

analyzedtokens = filter(row -> row[:lexeme] != "ls.null", lexicalanalyses)

# ╔═╡ 19d99d74-6000-11eb-14e0-b9d53da4d309
numanalyzedforms = length(unique(map(s -> lowercase(s), analyzedtokens[:,:token])))

# ╔═╡ b50c319a-5fda-11eb-20b9-bdfecd7bf342
numtokenanalyses = length(analyzedtokens[:, :urn])

# ╔═╡ 5189e0a4-5fda-11eb-3f9a-55915798af41
numanalyzedtokens = length(unique(analyzedtokens[:,:urn]))

# ╔═╡ a76957c6-6001-11eb-013e-c99f340b3b95
pctanalyzed = pctOfTokens(numanalyzedtokens)

# ╔═╡ 79242f72-6005-11eb-1226-d59e8a6ba865
formdict = countmap(analyzedtokens[:,:token])

# ╔═╡ 790c0a32-6005-11eb-33a2-39aa86a4d16b
orderedformcounts = sort(collect(formdict), by=pr->pr[2], rev=true)

# ╔═╡ b50c952e-6005-11eb-16f6-e7fa560adf7a
singletons = length(filter(pr -> pr[2] == 1, orderedformcounts))

# ╔═╡ 6c915066-5ff4-11eb-30ce-7b604d2dec6b
md"""
**Overview**

| Feature | Count | 
| --- | --- | 
| "Words" in text (lexical tokens) | **$(numlexicaltokens)** |
| Distinct word forms | **$(numanalyzedforms)** |
| Forms appearing only once | **$(singletons)** |
| Parsed tokens | **$(numanalyzedtokens)** |
| Percent parsed | **$(pctanalyzed)** |
| "Vocabulary items" (lexemes) | **$(numlexemes)** |

"""

# ╔═╡ 641c6d98-6004-11eb-310f-2777b799f823
lexdict = countmap(analyzedtokens[:,:lexeme])

# ╔═╡ c64149e4-6004-11eb-17ac-f7679ef9e0ca
orderedlexcounts = sort(collect(lexdict), by=pr->pr[2], rev=true)

# ╔═╡ a748dec0-5fe5-11eb-1c5f-1de64446f8a3
tknlexicalanalyses = begin
	filter(row -> row[:category] == "LexicalToken", tknanalysesdf)
end

# ╔═╡ Cell order:
# ╟─02e34e8c-5fd9-11eb-1306-6309a87a36bd
# ╟─f9075e6c-5fd8-11eb-198f-354c922bfd61
# ╟─dfb69194-5fd8-11eb-2bad-e7e6201ff5aa
# ╟─6c915066-5ff4-11eb-30ce-7b604d2dec6b
# ╟─54d1e082-5fd9-11eb-233b-39f68c5cbbc6
# ╟─5eb787e6-5fd9-11eb-3fc3-81912954efb6
# ╟─9c23719c-5ff4-11eb-0be1-4d2231ad9135
# ╟─19d99d74-6000-11eb-14e0-b9d53da4d309
# ╟─b50c319a-5fda-11eb-20b9-bdfecd7bf342
# ╟─5189e0a4-5fda-11eb-3f9a-55915798af41
# ╟─a76957c6-6001-11eb-013e-c99f340b3b95
# ╟─b50c952e-6005-11eb-16f6-e7fa560adf7a
# ╟─8b3f7954-6001-11eb-176b-2d5282839751
# ╟─953e8df6-6005-11eb-0afb-5bc35be589b8
# ╟─79242f72-6005-11eb-1226-d59e8a6ba865
# ╟─641c6d98-6004-11eb-310f-2777b799f823
# ╠═c64149e4-6004-11eb-17ac-f7679ef9e0ca
# ╟─790c0a32-6005-11eb-33a2-39aa86a4d16b
# ╟─4713512e-5fd9-11eb-06d6-2ba2419c6252
# ╠═374aeeac-5ff5-11eb-3ccd-b31b5d4e75f0
# ╟─58134b9c-5fe5-11eb-35a0-cf70533dda53
# ╟─c563f48c-5ff4-11eb-2a2f-c5a6ee001fd2
# ╟─6c9033b6-5fe5-11eb-3a26-03358ad850bd
# ╠═a748dec0-5fe5-11eb-1c5f-1de64446f8a3
