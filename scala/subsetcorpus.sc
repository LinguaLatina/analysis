// From full text of Pliny, create a new corpus
// comprising only letters included in the commentary by Jo-Ann Shelton

import scala.io.Source
import edu.holycross.shot.cite.CtsUrn
import edu.holycross.shot.ohco2._
import java.io.PrintWriter
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._

// list of passages in Shelton
val passageList = "data/pliny/shelton-urns.txt"
val passageUrns = Source.fromFile(passageList).getLines.toVector.map(psg => CtsUrn(psg))
// full text of Pliny's letters
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/pliny-letters.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)

// recursively extract  all passages in list
// and concatenate to create  a new corpus.
//
// psgUrns: list of passages to add
// srcCorpus: full corpus to draw from
// newCorpus: resulting recursively concatenated corpus
def extract(psgUrns: Vector[CtsUrn], srcCorpus: Corpus, newCorpus: Corpus = Corpus(Vector.empty[CitableNode])) :  Corpus = {

  if (psgUrns.isEmpty) {
    println("\nNew corpus has a total of " + newCorpus.size + " citable nodes.")
    newCorpus

  } else {
    println("Extracting " + psgUrns.head + "...")
    val extractedPassage = srcCorpus ~~ psgUrns.head
    println("Matched a total of " + extractedPassage.size + " citable nodes.")
    extract(psgUrns.tail, srcCorpus, newCorpus ++ extractedPassage)
  }
}



// write corpus to file in CEX format
def writeCorpus(outputFile: String = "shelton.cex"): Unit = {
  val shelton = extract(passageUrns, corpus)
  new PrintWriter(outputFile){write(shelton.cex());close}
  println("Wrote new corpus to " + outputFile)
}

// tell 'em how to do it'
def usage = {
  println("\n\nUSAGE:")
  println("=====\n")
  println("Data already loaded as named values:\n")
  println("- `corpus` is a full corpus of Pliny's letters")
  println("- `passageUrns` is a list of URNs for letters in Shelton's selection")
  println("\nTo extract all passages in Shelton from full text of Pliny")
  println("as a new citable corpus:\n")
  println("\tval shelton = extract(passageUrns, corpus)\n")
  println("Write Shelton corpus to a file in CEX format:\n")
  println("\twriteCorpus(\"FILENAME\")")
}

import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/LinguaLatina/morphology/master/urnmanager/config.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)


def updateShelton = {
  println("Loading FST data...")
  import scala.io.Source
  val fstUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/pliny/pliny-fst.txt"
  val fstLines = Source.fromURL(fstUrl).getLines.toVector
  println("Done.")

  val shelton = extract(passageUrns, corpus)
  val lat24orthogaphy: MidOrthography = Latin24Alphabet
  println("Building LatinCorpus from FST:")
  println("please be patient...")
  val latinCorpus = LatinCorpus.fromFstLines(shelton,lat24orthogaphy, fstLines, strict=false)
  println("Done.")
  val outFile = "shelton-latc.cex"
  new PrintWriter(outFile){write(latinCorpus.cex(manager)); close;}
  println("\nCEX serialization of Shelton selections written to " + outFile + ".")
}

usage