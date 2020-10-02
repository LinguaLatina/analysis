import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._

// This file should be an extract of the three columns
// passage#token#lexeme
// from our token source.
val f = "columns-for-app.cex"

val lines = Source.fromFile(f).getLines.toVector.tail
val columns = lines.map(_.split("#").toVector)

val passagesForPages = columns.map(v => CtsUrn(v.head).collapsePassageBy(2).passageComponent)

val passages =  columns.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)

val tokenStrings = columns.map(v => v(1))
val lexemes = columns.map(v => v(2))
val labelled  = lexemes.map(lex => LewisShort.label("ls." + Cite2Urn(lex).objectComponent))

val hdr = "url#passage#token#lexeme\n"
val records = for ((p,i) <- passagesForPages.zipWithIndex) yield {
  val url = s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/"
  List(url, passages(i), tokenStrings(i), labelled(i)).mkString("#")
}

import java.io.PrintWriter
new PrintWriter("for-observable.cex"){write(hdr + records.distinct.mkString("\n")); close;}
