### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ f9075e6c-5fd8-11eb-198f-354c922bfd61
# Set up environment
begin
	using Pkg
	Pkg.activate(".")
	
	using CSV
	using DataFrames
	using Plots
	
	using PlutoUI
end

# ╔═╡ 02e34e8c-5fd9-11eb-1306-6309a87a36bd
md"Define environment in hidden cell."

# ╔═╡ dfb69194-5fd8-11eb-2bad-e7e6201ff5aa
md"Vocabulary in Hyginus, take 2"

# ╔═╡ 54d1e082-5fd9-11eb-233b-39f68c5cbbc6
md"> Compute overview"

# ╔═╡ 5189e0a4-5fda-11eb-3f9a-55915798af41
#numlexicalanalyses = length(lexicaltokens[:, :token])

# ╔═╡ b8e9db14-5fda-11eb-0f7c-dbae5e8f055f
numdistintcttokens = 0

# ╔═╡ 4713512e-5fd9-11eb-06d6-2ba2419c6252
md"> Loading data"

# ╔═╡ 29166710-5fd9-11eb-0814-97edda0dfd4a
# Future version should compute this here in Pluto
countsfile = pwd() * "/tokensPerLexeme.cex"

# ╔═╡ 9e6da0fa-5fd9-11eb-0179-4d1c81284f59
analysesfile = pwd() * "/morphologysummary.cex"

# ╔═╡ dc037df4-5fd9-11eb-0ef0-5f771df8e9e5
punct = [".", ",", ":", ";", "?"]

# ╔═╡ ae912fc4-5fd9-11eb-0a1a-038a99f91251
analysesdf = CSV.File(analysesfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ b50c319a-5fda-11eb-20b9-bdfecd7bf342
numanalyzedtokens = length(analysesdf[:, :token])

# ╔═╡ e9700fe8-5fd9-11eb-2b79-d35857899a98
lexicalanalyses = filter(row -> !(row[:token] in punct), analysesdf)

# ╔═╡ 2a544a24-5fda-11eb-2e74-85af1d4965ad
numlexicalanalyses = length(lexicalanalyses[:, :token])

# ╔═╡ 3b0460e4-5fd9-11eb-1f24-45baf1fa81d3
# Counts per lexeme as a dataframe
countsdf = CSV.File(countsfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 5eb787e6-5fd9-11eb-3fc3-81912954efb6
numlexemes = length(countsdf[:, :lexeme])

# ╔═╡ Cell order:
# ╟─02e34e8c-5fd9-11eb-1306-6309a87a36bd
# ╟─f9075e6c-5fd8-11eb-198f-354c922bfd61
# ╟─dfb69194-5fd8-11eb-2bad-e7e6201ff5aa
# ╟─54d1e082-5fd9-11eb-233b-39f68c5cbbc6
# ╟─5eb787e6-5fd9-11eb-3fc3-81912954efb6
# ╟─b50c319a-5fda-11eb-20b9-bdfecd7bf342
# ╟─2a544a24-5fda-11eb-2e74-85af1d4965ad
# ╠═5189e0a4-5fda-11eb-3f9a-55915798af41
# ╠═b8e9db14-5fda-11eb-0f7c-dbae5e8f055f
# ╟─4713512e-5fd9-11eb-06d6-2ba2419c6252
# ╟─29166710-5fd9-11eb-0814-97edda0dfd4a
# ╟─9e6da0fa-5fd9-11eb-0179-4d1c81284f59
# ╟─dc037df4-5fd9-11eb-0ef0-5f771df8e9e5
# ╟─e9700fe8-5fd9-11eb-2b79-d35857899a98
# ╟─ae912fc4-5fd9-11eb-0a1a-038a99f91251
# ╟─3b0460e4-5fd9-11eb-1f24-45baf1fa81d3
