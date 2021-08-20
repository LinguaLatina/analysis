// Compose TSV file in 4 columns for Observable notebook.
// The structure for for each citable node of text is:
// 1) URL linking to online page,
// 2) passage component of URN,
// 3) text content
// 4) lexeme

import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._
import java.io.PrintWriter

// This file should be an extract of the three columns
// passage#token#lexeme
// from our token source.
// token source is data/hyginus/hyginus-latc.cex


val f = "data/hyginus/hyginus-latc.cex"


// extract cols 2-4 from token corpus.
def extractColumns(fName: String = f) = {
  val lines = Source.fromFile(f).getLines.toVector.tail
  val allColumns = lines.map(_.split("#").toVector)
  allColumns.map(v => Vector(v(2), v(3), v(4)))
}


/*

//
val chapters = passageVectors.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)
val urls =  chapters.map(p => s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/")



val tokenStrings = columns.map(v => v(1))
val lexemes = columns.map(v => v(2))
val labelled  = lexemes.map(lex => LewisShort.label("ls." + Cite2Urn(lex).objectComponent))

val hdr = "url#passage#token#lexeme\n"
val records = for ((p,i) <- passagesForPages.zipWithIndex) yield {
  val url = s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/"
  List(url, passages(i), tokenStrings(i), labelled(i)).mkString("#")
}
*/

def writeFile() = {
  //new PrintWriter("for-observable.cex"){write(hdr + records.distinct.mkString("\n")); close;}
}
