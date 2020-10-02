import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._


val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"

val lines = Source.fromURL(url).getLines.toVector.tail
val columns = lines.map(_.split("#").toVector)

val passagesForPages = columns.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)

val passages =  columns.map(v => CtsUrn(v.head).passageComponent)

val passageText = columns.map(v => v(1))


val hdr = "url#passage#text\n"
val records = for ((p,i) <- passagesForPages.zipWithIndex) yield {
  val url = s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/"
  List(url, passages(i), passageText(i)).mkString("#")
}

import java.io.PrintWriter
new PrintWriter("text-for-observable.cex"){write(hdr + records.distinct.mkString("\n")); close;}
