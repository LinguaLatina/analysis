
/*
Hyginus: overall occurrence of subjunctive: include all tenses, even those with no subjunctive forms.

The same code is available in a Jupyter notebook that you can run in a web
browser from:

https://mybinder.org/v2/gh/lingualatina/lingualatina-ipynb/master?filepath=course-planning%2Flibatique-machado-2020%2Flibatique-machado-2020-1.ipynb
*/

import edu.holycross.shot.latincorpus._
val hyginusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"
val hyginus = LatinCorpus.fromUrl(hyginusUrl)


// Overview of the corpus:
println("Total tokens / lexical tokens / analyzed:")
println(hyginus.tokens.size + " total tokens / " + hyginus.lexicalTokens.size + " lexical tokens / " + hyginus.analyzed.size + " morphologically analyzed")
println("Possible forms / tokens analyzed")
println(hyginus.allAnalyses.size + " / " + hyginus.analyzed.size)

println("Tokens analyzed / finite verb tokens")
println(hyginus.analyzed.size + " tokens / " + hyginus.verbs.size + " finite verb tokens")

// Limit to tokens with all analyses in the same mood
import edu.holycross.shot.tabulae._
// True if all analyses are in the same mood
def uniformMood(analyses: Vector[LemmatizedForm]): Boolean = {
  val distinctMoods = analyses.map(a => a.verbMood).distinct
  distinctMoods.size == 1
}

val pureMood = hyginus.verbs.filter(tkn => uniformMood(tkn.analyses))
val mixedMood = hyginus.verbs.filterNot(tkn => uniformMood(tkn.analyses))
println("Single mood / multiple moods")
println(pureMood.size + " / " + mixedMood.size)

// Extract mood value from analysis and compute frequencies:
val moods = pureMood.map(tkn => tkn.analyses.head.verbMood.get)
val groupedByMood = moods.groupBy(mood => mood)
val frequencies = groupedByMood.toVector.map{ case (k,v) => (k, v.size) }

// Compute percent, rounded to integer:
val percents = frequencies.map(f => (f._1, ((f._2 / total) * 100).toInt)).sortBy(pct => pct._2).reverse


println(percents.mkString("\n"))
