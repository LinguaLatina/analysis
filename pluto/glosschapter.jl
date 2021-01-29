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

# ╔═╡ 1dcc0106-6260-11eb-1ed1-0526238f0561
css = html"""
<style>
 .missing {
  text-decoration-line: underline;
  text-decoration-style: wavy;
  text-decoration-color: red;
}
</style>
"""

# ╔═╡ 7073d880-624e-11eb-3a1f-416728ba1ddc
hyginusurn = CtsUrn("urn:cts:latinLit:stoa1263.stoa001:")

# ╔═╡ bed20180-624d-11eb-3d89-8b5d8e66a8a2
md"""

>## Vocabulary needing glossing in Hyginus
>
> - Select a passage.  
> - Words not included in 250-word core vocabulary are highlighted.
>
"""

# ╔═╡ 19461920-624f-11eb-24d1-1b2156c42f1b
md"""

---


> Computation for displaying selected chapter:  functions to find URNs

"""

# ╔═╡ eb5ca2fe-6253-11eb-33bc-b3cbb2ad8782
md"These are the URNs of the subsections within the currently selected chapter."

# ╔═╡ 13e24cba-6254-11eb-3112-f79caa85c8dc
md"This function finds unique token URNs for a specified subsection"

# ╔═╡ e2aaf91e-6260-11eb-291f-a7cd48f93af6
md">Computation for displaying selected chapter: functions composing HTML"

# ╔═╡ e317e680-6253-11eb-2958-59a785fff2b6
md">Subset of data for the currently selected chapter."

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
	#
	
	filtered = filter(row -> urncontains(subUrn, row[:urn]), sectionanalyses)
	tokenurns = unique(filtered[:, :urn])
	filter(u -> urncontains(subUrn, u), tokenurns)
end

# ╔═╡ 237ffa14-624f-11eb-3c16-d94e840324d4
# Find distinct subsections for currently selected chapter
function subsectionUrns()
	tknurns = sectionanalyses[:, :urn]
	trimmed = unique(map(t -> collapsePassageBy(t, 1), tknurns))
end

# ╔═╡ da020188-624f-11eb-0b50-072b58325c4b
subsectionUrns()

# ╔═╡ 01b413a2-624f-11eb-10ce-e3fa6ee75008
groupedbytoken = begin 
	groupby(tokenlexdf, :urn)
end


# ╔═╡ 8535af42-625e-11eb-18cc-f556747dcb39
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

# ╔═╡ ba3d6430-6251-11eb-0258-d3441fcd7473
# Format a single token identified by URN
function formatToken(tknurn)
	#filter(t -> urncontains(tknu, t[:urn]), sectionanalyses)
	#groupedbytoken[(),]
	analysesfortoken = groupedbytoken[(tknurn,)]
	lexemesfortoken = analysesfortoken[:,:lexeme]
	tstrings = analysesfortoken[:,:token]
	overlaps = intersect(lexemesfortoken, vocablist)
	# NOW DO THE THING WHERE UYOU COLLECT AND CHECK FOR OVERLAP!
	 if isempty(overlaps)
     	"<span class='missing'>" * tstrings[1] * "</span>"
	else
        tstrings[1]
	end

end

# ╔═╡ 2052cd3e-625f-11eb-0ed9-098d155ea0f5
# Compose HTML for a labelled subsection of a passage 
function formatSubsection(suburn)
	label = "<b>" * passagecomponent(suburn) * "</b> "
	turns = tokenUrns(suburn)
	formattedtkns = map(tkn -> formatToken(tkn),turns)
	"<p>" * label * join(formattedtkns, " ") * "</p>"
end

# ╔═╡ f3cbc794-624e-11eb-2849-834454c2f4ad
begin
	txtgroups = map(sub -> formatSubsection(sub),subsectionUrns())
	htmltext = join(txtgroups, "\n\n")
	HTML(htmltext)
	
end


# ╔═╡ Cell order:
# ╟─c590e748-624d-11eb-188b-853d969346cb
# ╟─1dcc0106-6260-11eb-1ed1-0526238f0561
# ╟─7073d880-624e-11eb-3a1f-416728ba1ddc
# ╟─bed20180-624d-11eb-3d89-8b5d8e66a8a2
# ╟─2dddd6bc-624e-11eb-0cab-63c477b9a525
# ╟─5b169b0a-624e-11eb-182c-fd3c3b879496
# ╟─f3cbc794-624e-11eb-2849-834454c2f4ad
# ╟─19461920-624f-11eb-24d1-1b2156c42f1b
# ╟─eb5ca2fe-6253-11eb-33bc-b3cbb2ad8782
# ╟─da020188-624f-11eb-0b50-072b58325c4b
# ╟─17cb41f0-6250-11eb-1299-0d1c12e3c4f2
# ╟─13e24cba-6254-11eb-3112-f79caa85c8dc
# ╟─237ffa14-624f-11eb-3c16-d94e840324d4
# ╟─e2aaf91e-6260-11eb-291f-a7cd48f93af6
# ╟─2052cd3e-625f-11eb-0ed9-098d155ea0f5
# ╟─ba3d6430-6251-11eb-0258-d3441fcd7473
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
# ╟─8535af42-625e-11eb-18cc-f556747dcb39
