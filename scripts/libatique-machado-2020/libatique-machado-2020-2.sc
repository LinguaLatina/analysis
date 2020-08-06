


/*
Livy: active vs. passive voices. Limit to present active vs present passive system (present in all moods, imperfect)
*/
import edu.holycross.shot.latincorpus._
val url = "http://shot.holycross.edu/lingualatina/data/livy-latc.cex"
val livy = LatinCorpus.fromUrl(url)
//http://shot.holycross.edu/lingualatina/data

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

// True if all analyses are in the same mood
def uniformVoice(analyses: Vector[LemmatizedForm]): Boolean = {
  val distinctVoice= analyses.map(a => a.verbVoice).distinct
  distinctVoice.size == 1
}
// omit forms of sum: ls.n46529
val toBe = livy.verbs.filter(v => v.analyses.head.lemmaId == "ls.n46529")
val notToBe = livy.verbs.filterNot(v => v.analyses.head.lemmaId == "ls.n46529")

println("To be / Not to be")
println(toBe.size + " / " + notToBe.size)





val pureVoice = notToBe.filter(tkn => uniformVoice(tkn.analyses))
val mixedVoice = notToBe.filterNot(tkn => uniformVoice(tkn.analyses))


println("Pure voice / mixed voice")
println(pureVoice.size + " / " + mixedVoice.size)



val voices = pureVoice.map(tkn => tkn.analyses.head.verbVoice.get)
val groupedByVoice = voices.groupBy(voice => voice)
val frequencies = groupedByVoice.toVector.map{ case (k,v) => (k, v.size) }


val total = frequencies.map(_._2).sum.toDouble

val percents = frequencies.map(f => (f._1, ((f._2 / total) * 100).toInt)).sortBy(pct => pct._2).reverse


println(percents.map{ case (voice, count => voice + ": " + count }.mkString("\n"))


def pctForList(verbTokens: Vector[LatinParsedToken]) :  Vector[(Voice, Int)]= {
  val voices = verbTokens.map(tkn => tkn.analyses.head.verbVoice.get)
  val groupedByVoice = voices.groupBy(voice => voice)
  val frequencies = groupedByVoice.toVector.map{ case (k,v) => (k, v.size) }
  val total = frequencies.map(_._2).sum.toDouble
  val percents = frequencies.map(f => (f._1, ((f._2 / total) * 100).toInt)).sortBy(pct => pct._2).reverse
  percents
}

def printPctsForList(verbTokens: Vector[LatinParsedToken]) : Unit = {
  val pcts = pctForList(verbTokens)
  println(pcts.map{ case (voice, count) => voice + ": " + count }.mkString("\n"))
}

val presentTense = notToBe.filter(tkn => tkn.analyses.head.verbTense.get == Present)
printPctsForList(presentTense)

val imperfectTense = notToBe.filter(tkn => tkn.analyses.head.verbTense.get == Imperfect)
printPctsForList(imperfectTense)

val futureTense = notToBe.filter(tkn => tkn.analyses.head.verbTense.get == Future)
printPctsForList(futureTense)


println("Present / Imperfect / Future")
println(List(presentTense.size, imperfectTense.size, futureTense.size).mkString(" / "))

val presSystem = presentTense ++ imperfectTense ++ futureTense

printPctsForList(presSystem)
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
