import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._

// This file should be an extract of the three columns
// passage#token#lexeme
// from our token source.
val f = "observable-4cols.cex"

val lines = Source.fromFile(f).getLines.toVector.tail
val columns = lines.map(_.split("#").toVector)

val passagesForPages = columns.map(v => CtsUrn(v.head).collapsePassageBy(2).passageComponent)

val passages =  columns.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)

val tokenStrings = columns.map(v => v(1))
val lexemes = columns.map(v => v(2))
val labelled  = lexemes.map(lex => LewisShort.label("ls." + Cite2Urn(lex).objectComponent))

val morph = columns.map(v => v(3))
val morphlabels = morph.map(f => {
  if (f == "urn:cite2:tabulae:morphforms.v1:null") {
    "not analyzed"
  } else {
    ValidForm.labels(f)
  }
})

val hdr = "url#passage#token#lexeme#form\n"
val records = for ((p,i) <- passagesForPages.zipWithIndex) yield {
  val url = s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/"
  List(url, passages(i), tokenStrings(i), labelled(i), morphlabels(i)).mkString("#")
}

import java.io.PrintWriter
new PrintWriter("morphology-for-observable.cex"){write(hdr + records.distinct.mkString("\n")); close;}
