// Compose TSV file in 3 columns for Observable notebook.
// The structure for for each citable node of text is:
// 1) URL linking to online page,
// 2) passage component of URN,
// 3) text content


// github source for Hyginus text in CEX format:
val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"


import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._
import java.io.PrintWriter

// Load CEX text as Vector of records with URN + text
def loadCexData(textUrl: String = url) = {
  val lines = Source.fromURL(url).getLines.toVector.tail
  val columns = lines.map(_.split("#").toVector)
  columns
}

// Format TSV file as expected by Observable NB with 3 columns
// for each citable node of text:
// 1) URL linking to online page,
// 2) passage component of URN,
// 3) text content
//
def formatTsvRecords(passageVectors: Vector[Vector[String]] = loadCexData()) =  {
  val hdr = "url\tpassage\ttext\n"
  // 1. URL linking to online page:
  val chapters = passageVectors.map(v => CtsUrn(v.head).collapsePassageBy(1).passageComponent)
  val urls =  chapters.map(p => s"https://lingualatina.github.io/texts/browsable/hyginus/${p}/")
  // 2. Passage component of URN:
  val psgReff = passageVectors.map(v => v(0))
  // 3. Text content
  val txt = passageVectors.map(v => v(1))

  val records = for ((u,i) <- urls.zipWithIndex) yield {
    List(u, psgReff(i), txt(i)).mkString("\t")
  }
  hdr + records.mkString("\n")
}


// Write String to File.
def writeTsv(src: String = formatTsvRecords(), fName: String = "hyginustext-observable.tsv") {
  new PrintWriter(fName){write(src);close;}
}
