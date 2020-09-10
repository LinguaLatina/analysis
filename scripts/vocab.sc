val personalRepo = coursierapi.MavenRepository.of("https://dl.bintray.com/neelsmith/maven")
interp.repositories() ++= Seq(personalRepo)

import $ivy.`edu.holycross.shot::latincorpus:7.0.0-pr5`

import edu.holycross.shot.latincorpus._
import scala.io.Source

val vocabFiles : Map[Int, String] = Map(
  1 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/01-nouns-adjs-pron.cex",
  2 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/02-verbs.cex",
  3 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/03-place-and-time.cex",
  4 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/04-verbal-nouns-and-adjectives.cex",
  5 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/05-questions.cex",
  6 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/06-indirect-statement.cex",
  7 -> "https://raw.githubusercontent.com/LinguaLatina/textbook/master/vocablists/07-miscellany.cex"
)

val hyginusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"
val hyginus = LatinCorpus.fromUrl(hyginusUrl)


val tokens = hyginus.tokens.filter(_.text.head.isLower)

val total = tokens.size

val totalAnalyzed = tokens.filter(_.analyses.nonEmpty).size

val analysisCoverage = (totalAnalyzed * 1.0 / total) * 100
val analysisPct = BigDecimal(analysisCoverage).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble



val tempOmit = List(
  "ls.n49983",
  "ls.n40071",
  "ls.n25107",
  "ls.n28700",
  "ls.38383",
  "ls.n40913",
  "ls.n30584", // -ne
  "ls.n31181", // nonne
  "ls.n31181", // num
  "ls.n19471", // genu
  "s.n27977" // some kind of typo
)

def dataForUnit(vocabUnit: Int) : Vector[String] = {
  val vocab = for (i <- 1 to vocabUnit) yield {
    println("Loading data...")
    val lines = Source.fromURL(vocabFiles(i))
  }
}

def vocabForUnit(vocabUnit: Int): Vector[String] = {
  val vocab = for (i <- 1 to vocabUnit) yield {
    println("Loading data...")
    val lines = Source.fromURL(vocabFiles(i))
    println("Done.")
    val lexemeIds = lines.getLines.toVector.tail.filter(_.nonEmpty).map( ln => {
      val columns = ln.split("#")
      val idParts = columns.head.split(":")
      idParts.head
    })
    lexemeIds
  }
  vocab.toVector.flatten.filterNot(v => tempOmit.contains(v))
}




def unitCoverage(unitVocab: Vector[String]) = {
  val counts = unitVocab.flatMap(
    lex => hyginus.passagesForLexeme(lex)
  ).distinct.size
  val unitCoverage = (counts * 1.0 / total) * 100
  val unitPct = BigDecimal(unitCoverage).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble
}

def addPos(vocab: Vector[String]) = {
  vocab.map(
    lex  => (lex,
      hyginus.tokens.filter(t => t.matchesLexeme(lex)).head.analyses.head.posLabel
    )
  )
}


val unitVocab = vocabForUnit(1)
val pos = addPos(unitVocab)
val posGrouped = pos.groupBy(_._2)

posGrouped("indeclinable")


def listEm(unitNum: Int) = {
  val unitVocab =   vocabForUnit(unitNum).distinct.filterNot(l => tempOmit.contains(l))
  val pos = addPos(unitVocab)
  val posGrouped = pos.groupBy(_._2)
  val posCovered = posGrouped.keySet
  posGrouped("indeclinable")
}
