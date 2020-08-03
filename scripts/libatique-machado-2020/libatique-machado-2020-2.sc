
/*
Livy: active vs. passive voices. Limit to present active vs present passive system (present in all moods, imperfect)
*/

//https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/livy/livy-latc.cex
import scala.io.Source
import edu.holycross.shot.ohco2._
val livyTextUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/livy.cex"
val livyText = CorpusSource.fromUrl(livyTextUrl, cexHeader = true)
val livyMorphologyUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/livy/livy-parsed.txt"
val fstLines = Source.fromURL(livyMorphologyUrl).getLines.toVector

import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._
val livy = LatinCorpus.fromFstLines(livyText, Latin24Alphabet, fstLines, strict=false)

import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/neelsmith/tabulae/master/jvm/src/test/resources/datasets/analytical_types/urnregistry/collectionregistry.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)

val cex = livy.cex(manager)
import java.io.PrintWriter


// Corpus we'll look at:
println("Total tokens / lexical tokens / analyzed:")
println(livy.tokens.size + " total tokens / " + livy.lexicalTokens.size + " lexical tokens / " + livy.analyzed.size + " morphologically analyzed")
println("Possible forms / tokens analyzed")
println(livy.allAnalyses.size + " / " + livy.analyzed.size)

println("Tokens analyzed / finite verb tokens")
println(livy.analyzed.size + " tokens / " + livy.verbs.size + " finite verb tokens")


import edu.holycross.shot.tabulae._
// True if all analyses are in the same mood
def uniformMood(analyses: Vector[LemmatizedForm]): Boolean = {
  val distinctMoods = analyses.map(a => a.verbMood).distinct
  distinctMoods.size == 1
}

val pureMood = livy.verbs.filter(tkn => uniformMood(tkn.analyses))
val mixedMood = livy.verbs.filterNot(tkn => uniformMood(tkn.analyses))

val moods = pureMood.map(tkn => tkn.analyses.head.verbMood.get)
val groupedByMood = moods.groupBy(mood => mood)
val frequencies = groupedByMood.toVector.map{ case (k,v) => (k, v.size) }


val percents = frequencies.map(f => (f._1, ((f._2 / total) * 100).toInt)).sortBy(pct => pct._2).reverse


println(percents.map{ case (mood, count => mood + ": " + count }.mkString("\n"))
// PART 2: VOICE IN LIVY



// omit forms of sum: ls.n46529
val toBe = livy.verbs.filter(v => v.analyses.head.lemmaId == "ls.n46529")
val notToBe = livy.verbs.filterNot(v => v.analyses.head.lemmaId == "ls.n46529")

println("To be / Not to be")
println(toBe.size + " / " + notToBe.size)


// True if all analyses are to the same lexeme
def uniformLexeme(analyses: Vector[LemmatizedForm]): Boolean  = {
  val distinctLexemes = analyses.map(a => a.lemmaId).distinct
  distinctLexemes.size == 1
}
