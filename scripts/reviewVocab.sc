import edu.holycross.shot.latincorpus._
import edu.holycross.shot.histoutils._

import java.io.PrintWriter

def hyg : LatinCorpus = {
  val corpusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"
  LatinCorpus.fromUrl(corpusUrl)
}

def plin : LatinCorpus = {
  val corpusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/pliny/pliny-latc.cex"
  LatinCorpus.fromUrl(corpusUrl)
}

def shelt : LatinCorpus = {
  val corpusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/pliny/shelton-latc.cex"
  LatinCorpus.fromUrl(corpusUrl)
}

def hlc = LatinCorpus(hyg.tokens.filter(_.text.head.isLower))
def huc = LatinCorpus(hyg.tokens.filter(_.text.head.isUpper))


def ocre43k: LatinCorpus = {
  val corpusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/ocre/ocre-latc.cex"
  LatinCorpus.fromUrl(corpusUrl)
}


def failedHisto(c: LatinCorpus, outFile: String, includeUpperCase: Boolean = true): Unit = {
  val noAnalysisHisto = LatinCorpus(c.noAnalysis).tokensHistogram().sorted

  val resultFrequencies = if (includeUpperCase) {
    noAnalysisHisto.frequencies
  } else {
    noAnalysisHisto.frequencies.filterNot(_.item.head.isUpper)
  }
  new PrintWriter(outFile){write(resultFrequencies.map(_.cex()).mkString("\n"));close;}
  println("Wrote histogram of unanalyzed words to " + outFile)
}
