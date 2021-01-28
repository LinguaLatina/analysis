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

# ╔═╡ 4f5bf260-619c-11eb-2718-c9545ba95811
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

# ╔═╡ 472fff08-619c-11eb-0d5f-8bd3ae1f3dcd
md"Set up environment in hidden cell"

# ╔═╡ 329b64b8-619c-11eb-0aad-a9cc35786c31
md"## Gloss a passage of Hyginus"

# ╔═╡ 46401a5e-61a8-11eb-3570-f72b09b69b01
css = html"""
<style> 
  .highlight { background: yellow; } 
  .missing {
  text-decoration-line: underline;
  text-decoration-style: wavy;
  text-decoration-color: red;
}
</style>

"""

# ╔═╡ 405440e6-61a0-11eb-0e48-1f5e52c251ae
md"""
---

Data for currently seleted passage to gloss
"""

# ╔═╡ 221dbe24-61a1-11eb-3b27-135eff13c37a
#tknlevel = psg * ".2"

# ╔═╡ 2dcf838a-61a1-11eb-3bc1-b55806892965
#tknurn = addversion(addpassage(psgurn, tknlevel),"hc_tkns")

# ╔═╡ 5c4a229a-619e-11eb-0ffb-d9d66c466081
md"> Format data and UI"

# ╔═╡ 7cabc3cc-619e-11eb-011d-0bdaa9fa1029
hyginusurn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001:")

# ╔═╡ 6b6704fc-619c-11eb-2bec-c567d99716f3
md"""

--- 

> **Load data**
> Paste in core vocab. list for Latin 102, and read from file analyses of all tokens
"""

# ╔═╡ 9353d44a-619c-11eb-25c6-cf66bbbfc489
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

# ╔═╡ 6fd963e2-619c-11eb-0f1d-c36ff685cf27
analysisfile =  pwd() * "/pluto-token-analyses.cex"

# ╔═╡ 7eae38a0-619c-11eb-3592-ab43241cd96c
analysesdf = CSV.File(analysisfile, skipto=2, delim="|") |> DataFrame

# ╔═╡ 1d7a0d68-619d-11eb-23f8-e9d3f3e64670
psglist = begin
	newdata = Array{String}(undef,0)
	for r in eachrow(analysesdf)
		push!(  newdata, passagecomponent(collapsePassageBy(CtsUrn(r[:urn]), 1)))
	end
	stringsonly = filter(s -> typeof(s) <: AbstractString, newdata)
	unique(stringsonly)
end

# ╔═╡ 258b69f6-619d-11eb-1e0c-f9fb25d07a8d
md"Passage to gloss: $(@bind psg Select(psglist))"

# ╔═╡ a67a38d0-61a0-11eb-0ba1-29e8cfd56945
psgurn = addpassage(hyginusurn, psg)

# ╔═╡ 54100bc0-619f-11eb-199c-73f750aa2f76
tokenlexdf = begin
	urns = map(u -> CtsUrn(u), analysesdf[:, :urn])
	tokens = analysesdf[:, :token]
	lexemes = analysesdf[:, :lexeme]
	DataFrame(urn = urns, token = tokens, lexeme = lexemes)
end

# ╔═╡ 6704b952-619e-11eb-3a4d-bf899c82657c
psganalyses = begin 
	u = addpassage(hyginusurn, psg)
	filter(row -> urncontains(u, row[:urn]), tokenlexdf)
end


# ╔═╡ 0827eab0-61a0-11eb-295f-ad0b7462dc5c
groupedanalyses = begin 
	groupby(psganalyses, :urn)
end


# ╔═╡ 57e7fc3e-61a0-11eb-321c-d5bec1235449
function peeker(tknurn) 
	#tkn = psg * ".$(tnum)"
	#tknurn = addversion(addpassage(psgurn, tkn), "hc_tkns")
	analysesforgroup = groupedanalyses[(tknurn,)]
	tstrings = analysesforgroup[:,:token]

	possiblelexx = unique(analysesforgroup[:,:lexeme])
	overlaps = intersect(possiblelexx, vocablist)
	if isempty(overlaps)
				"<span class='missing'>" * tstrings[1] * "</span>"

	else
				tstrings[1]

	end
	
end

# ╔═╡ a6b453b4-61a8-11eb-0b36-596e4daf4c11
begin
	psgurns = psganalyses[:, :urn]
	psgtokens = map(u -> peeker(u), psgurns)
	txt = join(psgtokens, " ")
	HTML(txt)
end

# ╔═╡ 83cc0e48-61a1-11eb-08f1-fd4316cd0b73
peeker(6)

# ╔═╡ 360f041c-61a1-11eb-023a-df8fef7fe2a2
groupedanalyses[(tknurn,)]

# ╔═╡ Cell order:
# ╟─472fff08-619c-11eb-0d5f-8bd3ae1f3dcd
# ╟─4f5bf260-619c-11eb-2718-c9545ba95811
# ╟─329b64b8-619c-11eb-0aad-a9cc35786c31
# ╟─258b69f6-619d-11eb-1e0c-f9fb25d07a8d
# ╟─a67a38d0-61a0-11eb-0ba1-29e8cfd56945
# ╠═a6b453b4-61a8-11eb-0b36-596e4daf4c11
# ╟─46401a5e-61a8-11eb-3570-f72b09b69b01
# ╟─405440e6-61a0-11eb-0e48-1f5e52c251ae
# ╠═57e7fc3e-61a0-11eb-321c-d5bec1235449
# ╠═83cc0e48-61a1-11eb-08f1-fd4316cd0b73
# ╠═221dbe24-61a1-11eb-3b27-135eff13c37a
# ╠═2dcf838a-61a1-11eb-3bc1-b55806892965
# ╠═360f041c-61a1-11eb-023a-df8fef7fe2a2
# ╠═6704b952-619e-11eb-3a4d-bf899c82657c
# ╠═0827eab0-61a0-11eb-295f-ad0b7462dc5c
# ╟─5c4a229a-619e-11eb-0ffb-d9d66c466081
# ╟─7cabc3cc-619e-11eb-011d-0bdaa9fa1029
# ╟─1d7a0d68-619d-11eb-23f8-e9d3f3e64670
# ╟─6b6704fc-619c-11eb-2bec-c567d99716f3
# ╟─9353d44a-619c-11eb-25c6-cf66bbbfc489
# ╟─54100bc0-619f-11eb-199c-73f750aa2f76
# ╟─6fd963e2-619c-11eb-0f1d-c36ff685cf27
# ╠═7eae38a0-619c-11eb-3592-ab43241cd96c
