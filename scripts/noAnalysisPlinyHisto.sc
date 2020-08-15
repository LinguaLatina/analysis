import edu.holycross.shot.latincorpus._
import java.io.PrintWriter

val f = "data/pliny/pliny-latc.cex"

println("Loading corpus from file..")
val pliny = LatinCorpus.fromFile(f)
println("Done.")
val noAnalysisFreqs = LatinCorpus(pliny.noAnalysis).tokensHistogram().sorted
//val lcFreqs = noAnalysisFreqs.frequencies.filterNot(_.item.head.isUpper)

val outfile = "pliny-fails-histogram.txt"
new  java.io.PrintWriter(outfile){write(lcFreqs.map(_.cex()).mkString("\n"));close;}

println("Wrote histogram of unanalyzed lower-case words to " + outfile)
println("Loading Shelton selections...")


val sheltonFile = "data/pliny/shelton-latc.cex"
val shelton = LatinCorpus.fromFile(sheltonFile)
val noAnalysisShelton = LatinCorpus(shelton.noAnalysis).tokensHistogram().sorted
val sheltonOut = "shelton-fails-histogram.txt"
new  java.io.PrintWriter(sheltonOut){write(noAnalysisShelton.frequencies.map(_.cex()).mkString("\n"));close;}
