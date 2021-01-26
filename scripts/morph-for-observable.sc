import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._

// This file should be an extract of the three columns
// passage#token#lexeme
// from our token source.
//val f = "observable-4cols.cex"
val f = "data/hyginus/hyginus-ptlf-pipe.cex"

val lines = Source.fromFile(f).getLines.toVector.tail
val columns = lines.map(_.split("\\|").toVector)


// Page identifiers are the containing element of the psg hierarchy
val passagesForPages = columns.map(v => CtsUrn(v.head).collapsePassageBy(2).passageComponent)
// Canonical passages are one tier above the token
val passages =  columns.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)
val tokenurns =  columns.map(v => CtsUrn(v.head))

// Break out columns of the matrix:
val tokenStrings = columns.map(v => v(1))
val lexemes = columns.map(v => v(2))
val labelled  = lexemes.map(lex => LewisShort.label("ls." + Cite2Urn(lex).objectComponent))
val morph = columns.map(v => v(3))
// and label forms
val morphlabels = morph.map(f => {
  if (f == "urn:cite2:tabulae:morphforms.v1:null") {
    "not analyzed"
  } else {
    ValidForm.labels(f)
  }
})

val hdr = "url|passage|token|tokenid|lexeme|form\n"
val records = for ((p,i) <- passagesForPages.zipWithIndex) yield {
  val url = s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/"
  List(url, passages(i), tokenStrings(i), passages(i) + ":" + tokenStrings(i),labelled(i), morphlabels(i)).mkString("|")
}

import java.io.PrintWriter
new PrintWriter("morphology-for-observable.cex"){write(hdr + records.distinct.mkString("\n")); close;}


// STUFF FOR MY ANALYSIS:
// This eliminates multianalyses for same lexeme
// for a single token.
val analyzedTokens = (labelled zip tokenurns).filterNot(_._1 == "ls.null")
val analyzedLexemes = analyzedTokens.distinct
// now get a histogram of part 1
val lexemesOnly = analyzedLexemes.map(_._1)
val counted = grouped.map{case (k,v) => (k, v.size) }
val sortedCounts = counted.toVector.sortBy(_._2).reverse


// num of tokens:
println("Distinct tokens:  " + tokenurns.distinct.size)

val formattedCounts = sortedCounts.map( pr => pr._1 + "|" + pr._2)
new PrintWriter("tokensPerLexeme.cex"){write("lexeme|count\n" + formattedCounts.distinct.mkString("\n")); close;}


val punct = Vector(",", ".", ":", ";", "?")
//tokenStrings.filterNot(s => .contains(s)).size

val triple = columns.map(r => Vector(r(0), r(1), r(2)))

case class Triplet(urn: CtsUrn, token: String, lexeme: String)

val triplets = triple.map(t => Triplet(CtsUrn(t(0)), t(1), t(2)))
val lextriplets = triplets.filterNot(t => punct.contains(t.token))
val lexgrouped = lextriplets.map(_.token).groupBy(t => t)
val lexformcounts = lexgrouped.toVector.map{ case (k,v) => (k, v.size) }
val numsingles = lexformcounts.filter(_._2 == 1).size


val analyzedtriplets = lextriplets.filterNot(_.lexeme == "urn:cite2:tabulae:ls.v1:null")