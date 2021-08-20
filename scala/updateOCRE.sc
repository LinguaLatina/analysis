// Composite of subpages of complete example, so you can Load
// and run in a console
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
import java.io.PrintWriter

// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/neelsmith/hctexts/master/cex/ocre43k.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)




import scala.io.Source
val fstUrl = "https://raw.githubusercontent.com/neelsmith/hctexts/master/workfiles/ocre/ocre-fst.txt"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

// NEED THIS FOR ORTHOGRAPHY, PROBABLY NEEDS UPDATING:
//import edu.holycross.shot.ocre._
//import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latincorpus._


import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/LinguaLatina/morphology/master/urnmanager/config.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)


def updateOCRE = {

  //val lat24orthogaphy: MidOrthography = Latin24Alphabet
  println("Building LatinCorpus from FST:")
  println("please be patient...")
  /*
  val latinCorpus = LatinCorpus.fromFstLines(corpus,lat24orthogaphy, fstLines, strict=false)
  println("Done.")
  val outFile = "pliny-latc.cex"
  new PrintWriter(outFile){write(latinCorpus.cex(manager)); close;}
  println("\nCEX serialization of LatinCorpus written to " + outFile + ".")
  */
}
