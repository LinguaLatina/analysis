### A Pluto.jl notebook ###
# v0.12.19

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

# ╔═╡ 3fc3a288-6081-11eb-2b57-1d82e31cd1d6
md"""

# Coverage of vocabulary list for Hyginus, *Fabulae*

Visualize percentage of tokens in each chapter of Hyginus accounted for by core 
vocabulary list here.
"""

# ╔═╡ 93298cc4-6081-11eb-08b9-d9691eae1e1e
md"""
### Vocab list to use

This could just as easily be dynamically constructed.
"""

# ╔═╡ 49794662-603a-11eb-0998-4ff796f8115c
vocablist = [
"ls.n40103:qui1",
"ls.n16278:et",
"ls.n40242:quis1",
"ls.n25029:is",
"ls.n46529:sum1",
"ls.n22111:in1",
"ls.n18185:filius",
"ls.n11872:cum1",
"ls.n11872:cum1",
"ls.n16519:ex",
"ls.n18173:filia",
"ls.n46498:sui",
"ls.n4:ab",
"ls.n665:ad",
"ls.n47174:suus",
"ls.n49975:ut",
"ls.n40262:quod1",
"ls.n15868:eo1",
"ls.n13804:dico2",
"ls.n24257:interficio",
"ls.n20640:hic",
"ls.n50442:venio",
"ls.n17516:facio",
"ls.n41625:rex1",
"ls.n14599:do1",
"ls.n4633:autem",
"ls.n34096:pater",
"ls.n21494:ille",
"ls.n32088:occido1",
"ls.n18705:frater",
"ls.n31151:non",
"ls.n20077:habeo",
"ls.n51298:volo1",
"ls.n30568:navis",
"ls.n28181:mater",
"ls.n24872:ipse",
"ls.n1896:alius2",
"ls.n29328:mitto",
"ls.n50883:video",
"ls.n35822:peto",
"ls.n30423:nascor",
"ls.n31564:ob",
"ls.n21343:idem",
"ls.n12361:de2",
"ls.n26465:liber1",
"ls.n3134:appello2",
"ls.n44608:soleo",
"ls.n25104:itaque",
"ls.n50039:uxor",
"ls.n40912:regnum",
"ls.n38952:propter",
"ls.n38340:primus",
"ls.n31131:nomen",
"ls.n47897:terra",
"ls.n40913a",
"ls.n41387:respondeo",
"ls.n24040:insula1",
"ls.n25264:jubeo",
"ls.n37196:postea",
"ls.n33879:pario2",
"ls.n31419:numerus",
"ls.n14847:duco",
"ls.n12628:dedo",
"ls.n37193:possum",
"ls.n10349:conjugium",
"ls.n28019:mare",
"ls.n9942:concumbo",
"ls.n8883:coepio",
"ls.n44096:si",
"ls.n41293:res",
"ls.n4275:atque",
"ls.n10361:conjunx",
"ls.n13573:deus",
"ls.n30583:ne1",
"ls.n4220:at",
"ls.n44583:sol",
"ls.n4453:audio",
"ls.n44798:soror",
"ls.n363:accipio",
"ls.n24717:invenio",
"ls.n21296:ibi",
"ls.n38383:pro1",
"ls.n24154:inter1",
"ls.n34595:per1",
"ls.n13847:dies",
"ls.n29604:mons",
"ls.n48671:trado",
"ls.n49762:unde",
"ls.n49420:tunc",
"ls.n43291:sed1",
"ls.n29724:mors",
"ls.n22699:inde",
"ls.n49871:unus",
"ls.n18442:flumen",
"ls.n40719:redeo",
"ls.n16074:equus",
"ls.n39941:quaero",
"ls.n38498:procreo",
"ls.n48489:tollo",
"ls.n43947:servo",
"ls.n6506:canis1",
"ls.n6524:cano",
"ls.n11004:converto",
"ls.n14902:dum",
"ls.n6614:capio1",
"ls.n14914:duo",
"ls.n26468:liber4",
"ls.n14774a:draco1",
"ls.n40911:regno",
"ls.n32583:omnis",
"ls.n50968:vinco",
"ls.n12677:defero",
"ls.n30624:neco",
"ls.n743:adduco",
"ls.n1659:aio",
"ls.n42157:sacer",
"ls.n25100:ita",
"ls.n37010:pono",
"ls.n34131:patria",
"ls.n37415:praecipito",
"ls.n6724:caput",
"ls.n34067:pastor",
"ls.n26903:locus",
"ls.n47727:templum",
"ls.n37241:postquam",
"ls.n42264:sagitta",
"ls.n47738:tempus",
"ls.n18127:fides1",
"ls.n2698:annus",
"ls.n16804:exeo",
"ls.n10701:consumo",
"ls.n11268:corpus",
"ls.n29945:multus",
"ls.n49615:ubi",
"ls.n30017:munus",
"ls.n2280:amo",
"ls.n42158:sacerdos1",
"ls.n18993:fulmen",
"ls.n41838:rogo",
"ls.n43703:sepelio",
"ls.n8938:cognosco",
"ls.n20866:homo",
"ls.n7640:ceterus",
"ls.n44562:socius",
"ls.n43722:septem",
"ls.n31309:nox",
"ls.n30080:murus",
"ls.n15002:dux",
"ls.n40248:quisque",
"ls.n51069:virgo",
"ls.n51337:voluntas",
"ls.n33851:pareo",
"ls.n2294:amor",
"ls.n37194:post",
"ls.n35756:pes",
"ls.n39429:puer",
"ls.n18209:fio",
"ls.n25106:item",
"ls.n46609:super2",
"ls.n26488:libet",
"ls.n3259:aqua",
"ls.n3665:arma",
"ls.n17964:fero",
"ls.n44227:signum",
"ls.n10632:constituo",
"ls.n38619:proficisco",
"ls.n29544:moneo",
"ls.n42201:sacro",
"ls.n33930:pars",
"ls.n31035:nitor1",
"ls.n34815:perduco",
"ls.n34771:percutio",
"ls.n9689:comprimo",
"ls.n24885:irascor",
"ls.n21752:immolo",
"ls.n21007:hospitium",
"ls.n23173:inferus",
"ls.n31628:obicio",
"ls.n31520:nutrix",
"ls.n2015:alter",
"ls.n34312:pecus1",
"ls.n36862:polliceor",
"ls.n27649:magnus1",
"ls.n31146:nomino",
"ls.n26891:loco",
"ls.n3250:apud",
"ls.n47579:taurus1",
"ls.n29733:mortalis",
"ls.n23109:infans",
"ls.n24241:intereo",
"ls.n15326:ego",
"ls.n38618:proficio",
"ls.n17092:expono",
"ls.n30681:nego",
"ls.n51266:voco",
"ls.n11570:cresco",
"ls.n20998:hospes",
"ls.n30776:neque",
"ls.n9489:commuto",
"ls.n30605:nec1",
"ls.n33843:parens2",
"ls.n44517:sive",
"ls.n5180:beneficium",
"ls.n40577:recipio",
"ls.n44805:sors",
"ls.n21980:impono",
"ls.n51238:vivo",
"ls.n19607:gladius",
"ls.n2976:aper1",
"ls.n2260:amitto",
"ls.n50735:vestis",
"ls.n4588:aurum",
"ls.n31537:nympha",
"ls.n35491:persequor",
"ls.n43803:sepultura",
"ls.n26479:libero",
"ls.n25350:jungo",
"ls.n10770:contendo",
"ls.n45225:stadium",
"ls.n3372:arbor1",
"ls.n32796:oppidum",
"ls.n17904:femina",
"ls.n40405:rapio",
"ls.n10309:conicio",
"ls.n34869:pereo",
"ls.n31124:nolo",
"ls.n30350:nam",
"ls.n40105:quia",
"ls.n40279:quoniam",
"ls.n40905:regius",
"ls.n33147:ostendo",
"ls.n38642:profugio",
"ls.n47473:tantus",
"ls.n27171:ludus",
"ls.n51034:vir",
"ls.n34447:pellis",
"ls.n4714:avis",
"ls.n29707:morior",
"ls.n35702:pervenio",
"ls.n18566:forma",
"ls.n40791:refero",
"ls.n38534:procus2"
]

# ╔═╡ 9d3b268c-6081-11eb-3a52-bf4b5d1fc7ad
md"### Coverage"

# ╔═╡ 2280e2fe-607e-11eb-06b2-7d9a9f497ef2
md"Size of plot: $(@bind h Slider(300:1000, show_value=false))"

# ╔═╡ 31e55c94-602d-11eb-2de3-4f1fe2399419
md"""

---

> Extract data for graph from text
"""

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


# ╔═╡ d5af93ee-607d-11eb-0293-01f4970bde44
xhover = map(p -> passagecomponent(p), psglist)

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

# ╔═╡ 040c187a-607e-11eb-06ef-dd5d48f3dbce
xs = 1:length(scores)

# ╔═╡ 01352a5c-607d-11eb-3ca2-0db45f6c4300
begin
	plotly()
	plot(xs, scores, legend=false, xlabel="Passage", ylabel="Pct. covered", size=(2*h,h), title="Core vocabulary coverage", hover=xhover, xaxis=nothing)
end

# ╔═╡ Cell order:
# ╟─13c2316a-602d-11eb-322f-e1dc63a2339c
# ╟─28e7b342-602d-11eb-304b-714e184ab0a3
# ╟─3fc3a288-6081-11eb-2b57-1d82e31cd1d6
# ╟─93298cc4-6081-11eb-08b9-d9691eae1e1e
# ╟─49794662-603a-11eb-0998-4ff796f8115c
# ╟─9d3b268c-6081-11eb-3a52-bf4b5d1fc7ad
# ╟─2280e2fe-607e-11eb-06b2-7d9a9f497ef2
# ╟─01352a5c-607d-11eb-3ca2-0db45f6c4300
# ╟─31e55c94-602d-11eb-2de3-4f1fe2399419
# ╟─040c187a-607e-11eb-06ef-dd5d48f3dbce
# ╟─d5af93ee-607d-11eb-0293-01f4970bde44
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
