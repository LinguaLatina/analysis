### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ c590e748-624d-11eb-188b-853d969346cb
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

# ╔═╡ bed20180-624d-11eb-3d89-8b5d8e66a8a2
md"Cleaner glossing of Hyginus"

# ╔═╡ 7073d880-624e-11eb-3a1f-416728ba1ddc
hyginusurn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001:")

# ╔═╡ 2040559c-6251-11eb-1d83-117503ef4fd5


# ╔═╡ 19461920-624f-11eb-24d1-1b2156c42f1b
md"""
> Computation for displaying selected chapter
>
>
"""

# ╔═╡ 6575db58-6251-11eb-0953-a101e7165253
formatSubsection(CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:29pr.title"))

# ╔═╡ 13e24cba-6254-11eb-3112-f79caa85c8dc
md"- This function finds unique token URNs for a specified subsection"

# ╔═╡ eb5ca2fe-6253-11eb-33bc-b3cbb2ad8782
md"- These are the URNs of the subsections within the currently selected chapter."

# ╔═╡ e317e680-6253-11eb-2958-59a785fff2b6
md"- These are the analyses for the currently selected chapter."

# ╔═╡ 3be67386-624e-11eb-07b4-a3396b0ce7d8
md"""
> Organize data conveniently for this notebook:
>
> 1. determine list of sections for popup menu
> 2. create `tokenlexdef`, a simpler DataFrame with token URN, token String and lexeme
> 3. group `tokenlexdef` by URN of tokens (1 or more analyses per token)


"""

# ╔═╡ ce46c6d2-624d-11eb-2c4a-9115c38fe523
md"> Load data"

# ╔═╡ d891cf2e-624d-11eb-3e9e-b74abed9de13
analysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ f6054b8a-624d-11eb-006e-0b194d78bccb
analysesdf = CSV.File(analysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 4acb266c-624e-11eb-2571-ed330d2905e8
# Compiles a list of section IDs from the full analysesdf.
function sections()
	newdata = Array{String}(undef,0)
	for r in eachrow(analysesdf)
		push!(  newdata, passagecomponent(collapsePassageBy(CtsUrn(r[:urn]), 2)))
	end
	stringsonly = filter(s -> typeof(s) <: AbstractString, newdata)
	unique(stringsonly)
end

# ╔═╡ 2dddd6bc-624e-11eb-0cab-63c477b9a525
md"*Section to gloss*: $(@bind sect Select(sections()))"

# ╔═╡ 5b169b0a-624e-11eb-182c-fd3c3b879496
sectionurn = addversion(addpassage(hyginusurn, sect), "hc_tkns")

# ╔═╡ 44c3d4d2-624e-11eb-3f18-d5320f5c211b
sectionlist = sections()

# ╔═╡ a9eee296-624e-11eb-04ba-b72a604ee79d
tokenlexdf = begin
	urns = map(u -> CtsUrn(u), analysesdf[:, :urn])
	tokens = analysesdf[:, :token]
	lexemes = analysesdf[:, :lexeme]
	DataFrame(urn = urns, token = tokens, lexeme = lexemes)
end

# ╔═╡ 9039acdc-624e-11eb-2a3e-4141ef08062b
# Filter all analyses for  section currently selected by user from popup menu
function analysesForSection()
	analyses = filter(row -> urncontains(sectionurn, row[:urn]), tokenlexdf)
end


# ╔═╡ 8466d9aa-624e-11eb-0683-1511ae4fec9e
sectionanalyses = analysesForSection()

# ╔═╡ 17cb41f0-6250-11eb-1299-0d1c12e3c4f2
# Give a URN for a sub section, find unique token URNs within that subsection
function tokenUrns(subUrn)
	label = "<b>" * passagecomponent(subUrn) * "</b>"
	
	filtered = filter(row -> urncontains(subUrn, row[:urn]), sectionanalyses)
	tokenurns = unique(filtered[:, :urn])
	filter(u -> urncontains(subUrn, u), tokenurns)
end

# ╔═╡ ae64d736-6253-11eb-2079-d9afe51cfb31
tokenUrns(CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:30pr.title"))


# ╔═╡ 237ffa14-624f-11eb-3c16-d94e840324d4
# Find distinct subsections for currently selected chapter
function subsectionUrns()
	tknurns = sectionanalyses[:, :urn]
	trimmed = unique(map(t -> collapsePassageBy(t, 1), tknurns))
end

# ╔═╡ f3cbc794-624e-11eb-2849-834454c2f4ad
begin
	txtgroups = map(sub -> formatSubsection(sub),subsectionUrns())
end


# ╔═╡ da020188-624f-11eb-0b50-072b58325c4b
subsectionUrns()

# ╔═╡ 01b413a2-624f-11eb-10ce-e3fa6ee75008
groupedbytoken = begin 
	groupby(tokenlexdf, :urn)
end


# ╔═╡ ba3d6430-6251-11eb-0258-d3441fcd7473
# Format a token identified by URN
function formatToken(tknurn)
	#filter(t -> urncontains(tknu, t[:urn]), sectionanalyses)
	#groupedbytoken[(),]
	analysesfortoken = groupedbytoken[(tknurn,)]
	
	# NOW DO THE THING WHERE UYOU COLLECT AND CHECK FOR OVERLAP!

end

# ╔═╡ 549ecbfc-6254-11eb-3eb0-f9f26b53089c
formatToken(CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc_tkns:29pr.title.0"))

# ╔═╡ Cell order:
# ╟─c590e748-624d-11eb-188b-853d969346cb
# ╟─bed20180-624d-11eb-3d89-8b5d8e66a8a2
# ╟─7073d880-624e-11eb-3a1f-416728ba1ddc
# ╟─2dddd6bc-624e-11eb-0cab-63c477b9a525
# ╟─5b169b0a-624e-11eb-182c-fd3c3b879496
# ╠═f3cbc794-624e-11eb-2849-834454c2f4ad
# ╟─2040559c-6251-11eb-1d83-117503ef4fd5
# ╠═19461920-624f-11eb-24d1-1b2156c42f1b
# ╠═6575db58-6251-11eb-0953-a101e7165253
# ╠═549ecbfc-6254-11eb-3eb0-f9f26b53089c
# ╠═ba3d6430-6251-11eb-0258-d3441fcd7473
# ╠═ae64d736-6253-11eb-2079-d9afe51cfb31
# ╟─13e24cba-6254-11eb-3112-f79caa85c8dc
# ╟─17cb41f0-6250-11eb-1299-0d1c12e3c4f2
# ╟─eb5ca2fe-6253-11eb-33bc-b3cbb2ad8782
# ╟─da020188-624f-11eb-0b50-072b58325c4b
# ╟─237ffa14-624f-11eb-3c16-d94e840324d4
# ╟─e317e680-6253-11eb-2958-59a785fff2b6
# ╠═8466d9aa-624e-11eb-0683-1511ae4fec9e
# ╟─9039acdc-624e-11eb-2a3e-4141ef08062b
# ╟─3be67386-624e-11eb-07b4-a3396b0ce7d8
# ╟─44c3d4d2-624e-11eb-3f18-d5320f5c211b
# ╟─4acb266c-624e-11eb-2571-ed330d2905e8
# ╟─a9eee296-624e-11eb-04ba-b72a604ee79d
# ╠═01b413a2-624f-11eb-10ce-e3fa6ee75008
# ╟─ce46c6d2-624d-11eb-2c4a-9115c38fe523
# ╟─d891cf2e-624d-11eb-3e9e-b74abed9de13
# ╠═f6054b8a-624d-11eb-006e-0b194d78bccb
