import edu.holycross.shot.latincorpus._
import java.io.PrintWriter

val hUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"

val hyginus = LatinCorpus.fromUrl(hUrl)

val noAnalysisFreqs = LatinCorpus(hyginus.noAnalysis).tokensHistogram().sorted

val lcFreqs = noAnalysisFreqs.frequencies.filterNot(_.item.head.isUpper)

new  java.io.PrintWriter("hyg-fails-histogram.txt"){write(lcFreqs.map(_.cex()).mkString("\n"));close;}
