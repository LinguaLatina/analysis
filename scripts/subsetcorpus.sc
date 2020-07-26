// From full text of Pliny, create a new corpus
// comprising only letters included in the commentary by Jo-Ann Shelton

import scala.io.Source
import edu.holycross.shot.cite.CtsUrn
import edu.holycross.shot.ohco2._
// list of passages in Shelton
val passageList = "data/shelton.txt"
val passageUrns = Source.fromFile(passageList).getLines.toVector.map(psg => CtsUrn(psg))
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/pliny-letters.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)

// recursively extract  all passages in list
// and concatenate to create  a new corpus

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

def usage = {
  println("\n\nTo extract all passages in Shelton from full text of Pliny:\n")
  println("\textract(passageUrns, corpus)")
}


usage
