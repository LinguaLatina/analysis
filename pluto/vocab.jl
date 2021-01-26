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

# ╔═╡ f71fcce0-5e9c-11eb-0290-9b1324365bae
# Set up environment
begin
	using Pkg
	Pkg.activate(".")
	
	using CSV
	using DataFrames
	using Plots
	
	using PlutoUI
end

# ╔═╡ ce71a030-5f66-11eb-2933-cbbf363195c4
md"Define environment in a hidden cell."

# ╔═╡ 2df7cf52-5e9f-11eb-0bbe-e908323d7e36
md"## Understanding vocabulary usage in Hyginus"

# ╔═╡ cb3d8762-5f75-11eb-2c5d-a91387f8dca7
md"### How much coverage does a vocabulary set offer?"

# ╔═╡ 19f22bb0-5fc1-11eb-00de-d1ec4ba1a1d3
md"Width of graph display: $(@bind w Slider(300:1000, show_value=false))"

# ╔═╡ 03c5a9b6-5f76-11eb-2f11-579e5d662fb5
md"""
---

> Source data

"""

# ╔═╡ b18c1eb4-5f77-11eb-31c4-5db8a9eb94b5
md"Output of Scala functions:"

# ╔═╡ fcbbca96-5f65-11eb-0927-ab39c4c9a6be
# Number of lexical tokens
numlexicaltokens = 27805 # lextriplets.map(_.urn).distinct.size

# ╔═╡ 43cf27ea-5f66-11eb-3bb2-95178e01618b
# Number of analyzed lexical tokens
numanalyzedtokens = 21884 # analyzedtriplets.map(_.urn).distinct.size

# ╔═╡ 8fbdc3f2-5fb6-11eb-0d63-fb876e8634ab
# Number of distinct lexemes in analzyed tokens
numlexemes = 1303 # lextriplets.map(_.lexeme).distinct.size

# ╔═╡ edb03bda-5f66-11eb-0bf6-a78257aad06d
md"Size of vocabulary: $(@bind vocabsize Slider(100:numlexemes, show_value=true))"

# ╔═╡ 74b67f6e-5fbd-11eb-0bef-87c5684f65af
xs = 1:numlexemes

# ╔═╡ e4e12b0a-5fb7-11eb-051c-850cdfe3ef70
numforms = 8129 # lextriplets.map(_.token).distinct.size

# ╔═╡ 6c1f6cc6-5fb8-11eb-31f0-4338cc1bd02d
numsingletons = 4035 # lexformcounts.filter(_._2 == 1).size

# ╔═╡ b9f0d6ae-5f6a-11eb-2650-adc516f1cee3
md"""


| Feature | Count |
| --- | --- |
| "Words" (lexical tokens) in text | **$(numlexicaltokens)** |
| Total analyzed | **$(numanalyzedtokens)** |
| Percent analyzed | **$(round(100.0 * numanalyzedtokens / numlexicaltokens, digits=1))%** |
| Vocabulary items (lexemes) |  **$(numlexemes)** |
| Distinct forms | **$(numforms)** |
| Forms appaearing only once | **$(numsingletons)** |

"""

# ╔═╡ be87d070-5f77-11eb-21ce-7f37ad0bc402
md"File with counts per lexeme:"

# ╔═╡ c207882e-5f65-11eb-0f30-8bcf139992bd
countsfile = pwd() * "/tokensPerLexeme.cex"

# ╔═╡ d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
# Counts per lexeme as a dataframe
countsdf = CSV.File(countsfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
totals = cumsum(countsdf.count)


# ╔═╡ 890c8ae0-5f67-11eb-1371-37519971f572
# Add running total to counts per lexeme
hyginuscounts = DataFrame(lexemes = countsdf[:, :lexeme], count = countsdf[:, :count], runningtotal = totals, )

# ╔═╡ 7171d82e-5f6a-11eb-1afd-292ac77357a7
totalanalyzed = sum(hyginuscounts[1:vocabsize, :count])

# ╔═╡ 09e5fb2c-5f6a-11eb-2d1b-291631a1e70b
md"""

| Vocabulary size | Tokens recognized | Percent of tokens in Hyginus | 
| --- | --- | --- |
| **$(vocabsize)** |   **$(totalanalyzed)** |    **$(round(100.0 * totalanalyzed / numlexicaltokens, digits=2))**%  | 


"""

# ╔═╡ 21ccf17e-5fc0-11eb-3795-110394f98059
function countForVocab(nlex)
	sum(hyginuscounts[1:nlex, :count])
end

# ╔═╡ 5026601a-5fbd-11eb-2641-d708665ff94d
ys =   begin
	# totalanalyzed = sum(hyginuscounts[1:vocabsize, :count])
	map(le -> convert(Int64, round(100 * (countForVocab(le)  / numlexicaltokens))) , Vector(xs))
		
		
	#convert(Int64, round(100 * (countForVocab(le) / numlexicaltokens)), Vector(xs))
end


# ╔═╡ 0e64ecbe-5fbd-11eb-0405-955ddac49137
begin
	plotly()
	plot(xs, ys, legend=false, xlabel="Vocabulary size", ylabel="Percent covered", size=(w,w), title="Percent coverage for vocabulary size")
end

# ╔═╡ 355b40c0-5fc2-11eb-2ce6-d36125a7db68
function pctForVocab(n)
	runningtotal = countForVocab(n)
	
	round(100.0 * runningtotal / numlexicaltokens, digits=2)
	
end

# ╔═╡ a17e1e1c-5fc2-11eb-0c0c-c384b3ffb4a7
pctForVocab(100)

# ╔═╡ 2c52a2f0-5fc2-11eb-2118-91428e133a53
countForVocab(100)

# ╔═╡ 2ed426e6-5f67-11eb-0ccc-25d754113f40
selectedVocab = countsdf[1:vocabsize,:]

# ╔═╡ df1c060c-5fb9-11eb-2ea3-9d3a870894a5
#md"""Recognized words: **$(totalanalyzed)** / total words **$(numlexicaltokens)** == **$(round(100.0 * totalanalyzed / numlexicaltokens, digits=2))**% of all words in Hyginus"""


# ╔═╡ 32250f90-5f76-11eb-2367-f1ea80951c78
md"""
---

> ## Next project:  text passages

Delimited text files from repository

"""

# ╔═╡ c5e73476-5e9d-11eb-3601-9142b0a99f12
# "dirname" is the parent directory of the argument
tokensfile = dirname(pwd()) * "/morphology-for-observable.cex"

# ╔═╡ f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
tokensraw = CSV.File(tokensfile, skipto=2, delim="|")

# ╔═╡ 412c525a-5e9f-11eb-341c-a914e59797e9
tokensdf = tokensraw |> DataFrame


# ╔═╡ Cell order:
# ╟─ce71a030-5f66-11eb-2933-cbbf363195c4
# ╟─f71fcce0-5e9c-11eb-0290-9b1324365bae
# ╟─2df7cf52-5e9f-11eb-0bbe-e908323d7e36
# ╟─b9f0d6ae-5f6a-11eb-2650-adc516f1cee3
# ╟─cb3d8762-5f75-11eb-2c5d-a91387f8dca7
# ╟─19f22bb0-5fc1-11eb-00de-d1ec4ba1a1d3
# ╟─0e64ecbe-5fbd-11eb-0405-955ddac49137
# ╟─edb03bda-5f66-11eb-0bf6-a78257aad06d
# ╟─09e5fb2c-5f6a-11eb-2d1b-291631a1e70b
# ╟─74b67f6e-5fbd-11eb-0bef-87c5684f65af
# ╟─5026601a-5fbd-11eb-2641-d708665ff94d
# ╟─7171d82e-5f6a-11eb-1afd-292ac77357a7
# ╟─21ccf17e-5fc0-11eb-3795-110394f98059
# ╟─355b40c0-5fc2-11eb-2ce6-d36125a7db68
# ╠═2c52a2f0-5fc2-11eb-2118-91428e133a53
# ╠═a17e1e1c-5fc2-11eb-0c0c-c384b3ffb4a7
# ╟─03c5a9b6-5f76-11eb-2f11-579e5d662fb5
# ╟─b18c1eb4-5f77-11eb-31c4-5db8a9eb94b5
# ╟─fcbbca96-5f65-11eb-0927-ab39c4c9a6be
# ╟─43cf27ea-5f66-11eb-3bb2-95178e01618b
# ╟─8fbdc3f2-5fb6-11eb-0d63-fb876e8634ab
# ╟─e4e12b0a-5fb7-11eb-051c-850cdfe3ef70
# ╟─6c1f6cc6-5fb8-11eb-31f0-4338cc1bd02d
# ╟─be87d070-5f77-11eb-21ce-7f37ad0bc402
# ╟─c207882e-5f65-11eb-0f30-8bcf139992bd
# ╟─d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
# ╟─890c8ae0-5f67-11eb-1371-37519971f572
# ╠═ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
# ╠═2ed426e6-5f67-11eb-0ccc-25d754113f40
# ╠═df1c060c-5fb9-11eb-2ea3-9d3a870894a5
# ╟─32250f90-5f76-11eb-2367-f1ea80951c78
# ╟─c5e73476-5e9d-11eb-3601-9142b0a99f12
# ╟─f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
# ╟─412c525a-5e9f-11eb-341c-a914e59797e9
