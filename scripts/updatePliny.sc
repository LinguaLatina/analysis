// Composite of subpages of complete example, so you can Load
// and run in a console
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
import java.io.PrintWriter

// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/pliny-letters.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)




import scala.io.Source
val fstUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/pliny/pliny-fst.txt"
val fstLines = Source.fromURL(fstUrl).getLines.toVector


import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._


import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/LinguaLatina/morphology/master/urnmanager/config.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)


def updatePliny = {

  val lat24orthogaphy: MidOrthography = Latin24Alphabet
  println("Building LatinCorpus from FST:")
  println("please be patient...")
  val latinCorpus = LatinCorpus.fromFstLines(corpus,lat24orthogaphy, fstLines, strict=false)
  println("Done.")
  val outFile = "pliny-latc.cex"
  new PrintWriter(outFile){write(latinCorpus.cex(manager)); close;}
  println("\nCEX serialization of LatinCorpus written to " + outFile + ".")
}

def updateShelton = {
  val sheltonFile = "data/pliny/shelton.cex"
  val shelton = CorpusSource.fromFile(sheltonFile)

  val lat24orthogaphy: MidOrthography = Latin24Alphabet
  println("Building LatinCorpus from FST:")
  println("please be patient...")
  val latinCorpus = LatinCorpus.fromFstLines(shelton,lat24orthogaphy, fstLines, strict=false)
  println("Done.")
  val outFile = "shelton-latc.cex"
  new PrintWriter(outFile){write(latinCorpus.cex(manager)); close;}
  println("\nCEX serialization of LatinCorpus written to " + outFile + ".")

}
def usage : Unit = {
  println("Generate new CEX file for LatinCorpus of Pliny:\n")
  println("\tupdatePliny")
  println("\nGenerate new CEX file for LatinCorpus of Shelton selections:\n")
  println("\tupdateShelton")
}

usage
