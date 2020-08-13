// Composite of subpages of complete example, so you can Load
// and run in a console
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
import java.io.PrintWriter

// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)
//val c108a = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")


import scala.io.Source
val fstUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-fst.txt"
val fstLines = Source.fromURL(fstUrl).getLines.toVector


import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._


import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/LinguaLatina/morphology/master/urnmanager/config.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)


def updateHyginus = {

  val lat23orthogaphy: MidOrthography = Latin23Alphabet
  println("Building LatinCorpus from FST:")
  println("please be patient...")
  val latinCorpus = LatinCorpus.fromFstLines(corpus,lat23orthogaphy, fstLines, strict=false)
  println("Done.")
  val outFile = "hyginus-latc.cex"
  new PrintWriter(outFile){write(latinCorpus.cex(manager)); close;}
  println("\nCEX serialization of LatinCorpus written to " + outFile + ".")
}

def usage : Unit = {
  println("Generate new CEX file for LatinCorpus of Hyginus:\n")
  println("\tupdateHyginus")
}

usage