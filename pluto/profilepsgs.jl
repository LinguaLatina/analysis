### A Pluto.jl notebook ###
# v0.12.19

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
md"Set up environmet in hidden cell."

# ╔═╡ 31e55c94-602d-11eb-2de3-4f1fe2399419
md"Analyzing passages for a vocab list"

# ╔═╡ 49794662-603a-11eb-0998-4ff796f8115c
vocablist = ["ls.n16519:ex", "ls.n6259:caligo1", "ls.n16278:et"]

# ╔═╡ f93c7d58-6074-11eb-38d1-6376fdc8df87
md"> Load data"

# ╔═╡ 355b7672-602d-11eb-1195-adbe24f6f007
analysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ 3f89b91c-602d-11eb-166b-a7a8500172d1
analysesdf = CSV.File(analysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 765407c0-6075-11eb-3fee-873c1e797c39
# Parse real CtsUrns, and pair with lexemes 
lexemesWUrns = begin

	urns = []
	lexemes = []	
	for r in eachrow(analysesdf)
		if r[:category] == "LexicalToken"
			psg = collapsePassageBy(CtsUrn(r[:urn]),1)
			push!(urns, psg)
			push!(lexemes, r[:lexeme])
		end
	end
	DataFrame(passage = urns, lexeme = lexemes)
end


# ╔═╡ adfce2c8-607a-11eb-0132-4da26255c293
md"> Organize data for convenience of analysis"

# ╔═╡ d30b3f2e-607a-11eb-1bcd-ab7742ea0576
md"List of canonically citable passages"

# ╔═╡ 73713f38-603d-11eb-05f8-1f8ea5eedfe3
psglist = begin
	newdata = []
	for r in eachrow(analysesdf)
		push!(  newdata, collapsePassageBy(CtsUrn(r[:urn]), 1))
	end
	unique(newdata)
end


# ╔═╡ e2702892-607c-11eb-116e-85a4751b0c07
length(psglist)

# ╔═╡ c247be9c-607a-11eb-0657-ed120af85798
md"Lexemes grouped by canonically citable passage"

# ╔═╡ 460f6fce-6079-11eb-05c3-4dfe4a3dfc4d
groupedlexemes = groupby(lexemesWUrns,:passage)

# ╔═╡ 745b47f2-603a-11eb-0853-016cc5dd17d2
# Pct of lexemes in passage that are in vocab list
function scorePsg(u) 
	try 
		psggroup = groupedlexemes[(u,)]
		psglexemes = psggroup[:,:lexeme]
		inlist = filter(l -> l in vocablist, psglexemes)
		round(100 * length(inlist) / length(psglexemes), digits=1)
	catch e
		-1.0
	end
		
end

# ╔═╡ f0733c32-607b-11eb-2036-3b63df10cf6b
scores = map(p -> scorePsg(p), psglist)

# ╔═╡ dc173404-607c-11eb-20e4-755094701c18
length(scores)

# ╔═╡ Cell order:
# ╟─13c2316a-602d-11eb-322f-e1dc63a2339c
# ╟─28e7b342-602d-11eb-304b-714e184ab0a3
# ╟─31e55c94-602d-11eb-2de3-4f1fe2399419
# ╟─49794662-603a-11eb-0998-4ff796f8115c
# ╠═dc173404-607c-11eb-20e4-755094701c18
# ╠═e2702892-607c-11eb-116e-85a4751b0c07
# ╟─f0733c32-607b-11eb-2036-3b63df10cf6b
# ╟─745b47f2-603a-11eb-0853-016cc5dd17d2
# ╟─f93c7d58-6074-11eb-38d1-6376fdc8df87
# ╟─765407c0-6075-11eb-3fee-873c1e797c39
# ╟─355b7672-602d-11eb-1195-adbe24f6f007
# ╟─3f89b91c-602d-11eb-166b-a7a8500172d1
# ╟─adfce2c8-607a-11eb-0132-4da26255c293
# ╟─d30b3f2e-607a-11eb-1bcd-ab7742ea0576
# ╟─73713f38-603d-11eb-05f8-1f8ea5eedfe3
# ╟─c247be9c-607a-11eb-0657-ed120af85798
# ╠═460f6fce-6079-11eb-05c3-4dfe4a3dfc4d
