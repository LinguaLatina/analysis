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
	using FreqTables
	
	using PlutoUI
end

# ╔═╡ ce71a030-5f66-11eb-2933-cbbf363195c4
md"Define environment:"

# ╔═╡ 2df7cf52-5e9f-11eb-0bbe-e908323d7e36
md"## Frequency of vocabulary in Hyginus"

# ╔═╡ cb3d8762-5f75-11eb-2c5d-a91387f8dca7
md"### How much coverage does a vocabulary set offer?"

# ╔═╡ edb03bda-5f66-11eb-0bf6-a78257aad06d
md"Size of vocabulary: $(@bind vocabsize Slider(100:600, show_value=true))"

# ╔═╡ 03c5a9b6-5f76-11eb-2f11-579e5d662fb5
md"""
---

> Source data

"""

# ╔═╡ fcbbca96-5f65-11eb-0927-ab39c4c9a6be
totaltokens = 32465 # tokenurns.distinct.size in scala

# ╔═╡ 43cf27ea-5f66-11eb-3bb2-95178e01618b
analyzedtokens = 24320 # analyzedTokens.distinct.size

# ╔═╡ b9f0d6ae-5f6a-11eb-2650-adc516f1cee3
md"""

Overview:

- Total tokens (words) in text: $(totaltokens)
- Total analyzed: $(analyzedtokens)
"""

# ╔═╡ c207882e-5f65-11eb-0f30-8bcf139992bd
countsfile = dirname(pwd()) * "/tokensPerLexeme.cex"

# ╔═╡ d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
rawcounts = CSV.File(countsfile, skipto=2, delim="|")

# ╔═╡ c5e73476-5e9d-11eb-3601-9142b0a99f12
# "dirname" is the parent directory of the argument
f = dirname(pwd()) * "/morphology-for-observable.cex"

# ╔═╡ 32250f90-5f76-11eb-2367-f1ea80951c78
md"""

> Delimited text files from repository

"""

# ╔═╡ 584d566e-5f67-11eb-3cc7-dfe4e0ec5d82
# Vocabulary counts as a dataframe:
countsdf = rawcounts |> DataFrame

# ╔═╡ ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
totals = cumsum(countsdf.count)


# ╔═╡ 890c8ae0-5f67-11eb-1371-37519971f572
hyginuscounts = DataFrame(lexemes = countsdf[:, :lexeme], count = countsdf[:, :count], runningtotal = totals, )

# ╔═╡ 7171d82e-5f6a-11eb-1afd-292ac77357a7
totalanalyzed = sum(hyginuscounts[1:vocabsize, :count])

# ╔═╡ 09e5fb2c-5f6a-11eb-2d1b-291631a1e70b
md"Analyzed tokens: **$(totalanalyzed)** / total **$(totaltokens)** == **$(round(100.0 * totalanalyzed / totaltokens, digits=2))**%"

# ╔═╡ 5243e1a8-5f69-11eb-16b6-cb136ffce8a4
map(n -> 100.00 * n  ÷ totaltokens, hyginuscounts[:, :runningtotal])

# ╔═╡ 2ed426e6-5f67-11eb-0ccc-25d754113f40
countsdf[1:vocabsize,:]

# ╔═╡ 52fbaba2-5f76-11eb-3bd0-25a813b0d497
md"""

---

### Next project:  text passages

"""

# ╔═╡ f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
raw = CSV.File(f, skipto=2, delim="|")

# ╔═╡ 412c525a-5e9f-11eb-341c-a914e59797e9
df = raw |> DataFrame


# ╔═╡ Cell order:
# ╟─ce71a030-5f66-11eb-2933-cbbf363195c4
# ╟─f71fcce0-5e9c-11eb-0290-9b1324365bae
# ╟─2df7cf52-5e9f-11eb-0bbe-e908323d7e36
# ╠═b9f0d6ae-5f6a-11eb-2650-adc516f1cee3
# ╟─cb3d8762-5f75-11eb-2c5d-a91387f8dca7
# ╟─edb03bda-5f66-11eb-0bf6-a78257aad06d
# ╟─09e5fb2c-5f6a-11eb-2d1b-291631a1e70b
# ╟─03c5a9b6-5f76-11eb-2f11-579e5d662fb5
# ╠═890c8ae0-5f67-11eb-1371-37519971f572
# ╠═fcbbca96-5f65-11eb-0927-ab39c4c9a6be
# ╟─43cf27ea-5f66-11eb-3bb2-95178e01618b
# ╟─c207882e-5f65-11eb-0f30-8bcf139992bd
# ╠═7171d82e-5f6a-11eb-1afd-292ac77357a7
# ╠═5243e1a8-5f69-11eb-16b6-cb136ffce8a4
# ╟─d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
# ╟─c5e73476-5e9d-11eb-3601-9142b0a99f12
# ╠═ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
# ╠═2ed426e6-5f67-11eb-0ccc-25d754113f40
# ╟─32250f90-5f76-11eb-2367-f1ea80951c78
# ╟─584d566e-5f67-11eb-3cc7-dfe4e0ec5d82
# ╟─52fbaba2-5f76-11eb-3bd0-25a813b0d497
# ╟─f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
# ╟─412c525a-5e9f-11eb-341c-a914e59797e9
