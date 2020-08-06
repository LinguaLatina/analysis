
//https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/livy/livy-latc.cex
import scala.io.Source
import edu.holycross.shot.ohco2._
val livyTextUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/livy.cex"
val livyText = CorpusSource.fromUrl(livyTextUrl, cexHeader = true)
val livyMorphologyUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/livy/livy-parsed.txt"
val fstLines = Source.fromURL(livyMorphologyUrl).getLines.toVector

import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._
val livy = LatinCorpus.fromFstLines(livyText, Latin24Alphabet, fstLines, strict=false)

import edu.holycross.shot.tabulae._
val urnManagerUrl = "https://raw.githubusercontent.com/neelsmith/tabulae/master/jvm/src/test/resources/datasets/analytical_types/urnregistry/collectionregistry.cex"
val manager = UrnManager.fromUrl(urnManagerUrl)

val cex = livy.cex(manager)
import java.io.PrintWriter
