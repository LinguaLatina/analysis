### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 28e7b342-602d-11eb-304b-714e184ab0a3
# Set up environment
begin
	using Pkg
	Pkg.activate(".")
	Pkg.add("CitableText")
	Pkg.add("CSV")
	Pkg.add("DataFrames")
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("StatsBase")
		
	
	using CitableText
	using CSV
	using DataFrames
	using Plots
	using StatsBase
	
	using PlutoUI
end

# ╔═╡ 13c2316a-602d-11eb-322f-e1dc63a2339c
md"Try once again"

# ╔═╡ 31e55c94-602d-11eb-2de3-4f1fe2399419
md"Data"

# ╔═╡ 49794662-603a-11eb-0998-4ff796f8115c
vocablist = ["ls.n16519:ex", "ls.n6259:caligo1", "ls.n16278:et"]

# ╔═╡ 745b47f2-603a-11eb-0853-016cc5dd17d2
function scorePsg()
end

# ╔═╡ 355b7672-602d-11eb-1195-adbe24f6f007
analysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ d2007866-603d-11eb-3913-9904f042da64
begin
	dummy = []
	push!(dummy, "A")
end

# ╔═╡ 3f89b91c-602d-11eb-166b-a7a8500172d1
analysesdf = CSV.File(analysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 73713f38-603d-11eb-05f8-1f8ea5eedfe3
begin
	newdata = []
	for r in eachrow(analysesdf)
		push!(  newdata, collapsePassageBy(CtsUrn(r[:urn]), 1))
	end
	newdata
end


# ╔═╡ 745789c6-603c-11eb-1fff-3355fe224f54
groupby(analysesdf, :lexeme)

# ╔═╡ Cell order:
# ╟─13c2316a-602d-11eb-322f-e1dc63a2339c
# ╟─28e7b342-602d-11eb-304b-714e184ab0a3
# ╟─31e55c94-602d-11eb-2de3-4f1fe2399419
# ╟─49794662-603a-11eb-0998-4ff796f8115c
# ╠═745b47f2-603a-11eb-0853-016cc5dd17d2
# ╠═355b7672-602d-11eb-1195-adbe24f6f007
# ╠═73713f38-603d-11eb-05f8-1f8ea5eedfe3
# ╠═d2007866-603d-11eb-3913-9904f042da64
# ╠═745789c6-603c-11eb-1fff-3355fe224f54
# ╟─3f89b91c-602d-11eb-166b-a7a8500172d1
