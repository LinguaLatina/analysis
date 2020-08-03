
/*
Hyginus: overall occurrence of subjunctive: include all tenses, even those with no subjunctive forms.


Livy: active vs. passive voices. Limit to present active vs present passive system (present in all moods, imperfect)
*/

//https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex

import edu.holycross.shot.latincorpus._
val hyginusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"
val hyginus = LatinCorpus.fromUrl(hyginusUrl)


// Corpus we'll look at:
println("Total tokens / lexical tokens / analyzed:")
println(hyginus.tokens.size + " total tokens / " + hyginus.lexicalTokens.size + " lexical tokens / " + hyginus.analyzed.size + " morphologically analyzed")
println("Possible forms / tokens analyzed")
println(hyginus.allAnalyses.size + " / " + hyginus.analyzed.size)

println("Tokens analyzed / finite verb tokens")
println(hyginus.analyzed.size + " tokens / " + hyginus.verbs.size + " finite verb tokens")


import edu.holycross.shot.tabulae._
// True if all analyses are in the same mood
def uniformMood(analyses: Vector[LemmatizedForm]): Boolean = {
  val distinctMoods = analyses.map(a => a.verbMood).distinct
  distinctMoods.size == 1
}

val pureMood = hyginus.verbs.filter(tkn => uniformMood(tkn.analyses))
val mixedMood = hyginus.verbs.filterNot(tkn => uniformMood(tkn.analyses))

val moods = pureMood.map(tkn => tkn.analyses.head.verbMood.get)
val groupedByMood = moods.groupBy(mood => mood)
val frequencies = groupedByMood.toVector.map{ case (k,v) => (k, v.size) }


val percents = frequencies.map(f => (f._1, ((f._2 / total) * 100).toInt)).sortBy(pct => pct._2).reverse


println(percents.mkString("\n"))
// PART 2: VOICE IN LIVY



// omit forms of sum: ls.n46529
val toBe = hyginus.verbs.filter(v => v.analyses.head.lemmaId == "ls.n46529")
val notToBe = hyginus.verbs.filterNot(v => v.analyses.head.lemmaId == "ls.n46529")

println("To be / Not to be")
println(toBe.size + " / " + notToBe.size)


// True if all analyses are to the same lexeme
def uniformLexeme(analyses: Vector[LemmatizedForm]): Boolean  = {
  val distinctLexemes = analyses.map(a => a.lemmaId).distinct
  distinctLexemes.size == 1
}
