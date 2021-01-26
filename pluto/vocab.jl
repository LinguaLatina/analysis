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
md"Vocabulary in Hyginus"

# ╔═╡ fcbbca96-5f65-11eb-0927-ab39c4c9a6be
totaltokens = 32465 # tokenurns.distinct.size in scala

# ╔═╡ 43cf27ea-5f66-11eb-3bb2-95178e01618b
analyzedtokens = 24320 # analyzedTokens.distinct.size

# ╔═╡ c207882e-5f65-11eb-0f30-8bcf139992bd
countsfile = dirname(pwd()) * "/tokensPerLexeme.cex"

# ╔═╡ edb03bda-5f66-11eb-0bf6-a78257aad06d
md"Lexemes to take: $(@bind vocabsize Slider(100:600, show_value=true))"

# ╔═╡ d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
rawcounts = CSV.File(countsfile, skipto=2, delim="|")

# ╔═╡ c5e73476-5e9d-11eb-3601-9142b0a99f12
# "dirname" is the parent directory of the argument
f = dirname(pwd()) * "/morphology-for-observable.cex"

# ╔═╡ f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
raw = CSV.File(f, skipto=2, delim="|")

# ╔═╡ 412c525a-5e9f-11eb-341c-a914e59797e9
df = raw |> DataFrame


# ╔═╡ 59166112-5e9f-11eb-17f5-3977719fc067
# So now count freqs of lexeme but compute pct by unique tokenid

# ╔═╡ 584d566e-5f67-11eb-3cc7-dfe4e0ec5d82
countsdf = rawcounts |> DataFrame

# ╔═╡ ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
totals = cumsum(countsdf.count)


# ╔═╡ 890c8ae0-5f67-11eb-1371-37519971f572
hyginuscounts = DataFrame(lexemes = countsdf[:, :lexeme], count = countsdf[:, :count], runningtotal = totals, )

# ╔═╡ 5243e1a8-5f69-11eb-16b6-cb136ffce8a4
map(n -> 100.00 * n  ÷ totaltokens, hyginuscounts[:, :runningtotal])

# ╔═╡ 2ed426e6-5f67-11eb-0ccc-25d754113f40
countsdf[1:vocabsize,:]

# ╔═╡ Cell order:
# ╟─ce71a030-5f66-11eb-2933-cbbf363195c4
# ╟─f71fcce0-5e9c-11eb-0290-9b1324365bae
# ╟─2df7cf52-5e9f-11eb-0bbe-e908323d7e36
# ╟─fcbbca96-5f65-11eb-0927-ab39c4c9a6be
# ╟─43cf27ea-5f66-11eb-3bb2-95178e01618b
# ╟─c207882e-5f65-11eb-0f30-8bcf139992bd
# ╟─edb03bda-5f66-11eb-0bf6-a78257aad06d
# ╟─890c8ae0-5f67-11eb-1371-37519971f572
# ╠═5243e1a8-5f69-11eb-16b6-cb136ffce8a4
# ╟─d4c5914c-5f65-11eb-35f5-3fdac4f7fc6d
# ╟─c5e73476-5e9d-11eb-3601-9142b0a99f12
# ╠═f8171b6e-5e9d-11eb-1a02-3d3c6a7a5605
# ╠═412c525a-5e9f-11eb-341c-a914e59797e9
# ╠═59166112-5e9f-11eb-17f5-3977719fc067
# ╠═ebfea0f2-5f67-11eb-26c1-454e4c6b9c8e
# ╠═2ed426e6-5f67-11eb-0ccc-25d754113f40
# ╠═584d566e-5f67-11eb-3cc7-dfe4e0ec5d82
