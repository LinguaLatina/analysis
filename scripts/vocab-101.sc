/*
val personalRepo = coursierapi.MavenRepository.of("https://dl.bintray.com/neelsmith/maven")
interp.repositories() ++= Seq(personalRepo)

import $ivy.`edu.holycross.shot::latincorpus:7.0.0-pr5`
import $ivy.`edu.holycross.shot::tabulae:7.0.5`
*/
import edu.holycross.shot.latincorpus._
import edu.holycross.shot.tabulae._
import scala.io.Source


val hyginusUrl = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/hyginus/hyginus-latc.cex"
val hyginus = LatinCorpus.fromUrl(hyginusUrl)
val tokens = hyginus.tokens.filter(_.text.head.isLower)
val total = tokens.size



val vocabFile = "https://raw.githubusercontent.com/LinguaLatina/analysis/master/data/latin101/vocab101-ided.txt"
val vocab = Source.fromURL(vocabFile).getLines.toVector

def lexemeIds(vocabList: Vector[String] = vocab): Vector[String] = {
  val lexemeIds = vocabList.map(vocab => {

  })
  lexemeIds.filterNot(v => tempOmit.contains(v))
}


// Lexemes causing some sort of issue in analysis?
// Check out individually in morphology repo, and revisit this script.
// Meanwhile, omit these from analysis. :-(
/*
val tempOmit = List(
  "ls.n28054", //:maritus1
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
*/

/*
val totalAnalyzed = tokens.filter(_.analyses.nonEmpty).size

val analysisCoverage = (totalAnalyzed * 1.0 / total) * 100
val analysisPct = BigDecimal(analysisCoverage).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble
*/


// Read all data lines for vocabulary entries through a specified unit.
//
// vocabUnit: read vocab through this unit

def dataForUnit(vocabUnit: Int) : Vector[String] = {
  val vocab = for (i <- 1 to vocabUnit) yield {
    println(s"Loading data for unit ${i} ...")
    val lines = Source.fromURL(vocabFiles(i)).getLines.toVector
    lines.filter(_.nonEmpty)
  }
  vocab.flatten.toVector
}

// Extract all lexemeIds from data for unit
def lexemeIdsForUnit(vocabUnit: Int): Vector[String] = {
  val lexemeIds = dataForUnit(vocabUnit).map(ln => {
    val columns = ln.split("#")
    val idParts = columns.head.split(":")
    idParts.head
  })
  lexemeIds.filterNot(v => tempOmit.contains(v))
}


// Create map of labelled lexemes to vocabulary entries for all
// vocabulary through a specified unit.
//
// vocabUnit: include vocabulry through this unit
def vocabMapForUnit(vocabUnit: Int) : Map[String, String]= {
  val paired = dataForUnit(vocabUnit).map(ln => {
    val columns = ln.split("#")
    columns(0) -> columns(1)
  })
  paired.toMap
}


// get flat list of tokens for vocab through a given unit
def tokensForUnit(vocabUnit: Int): Vector[LatinParsedToken] = {
  val lexemes = lexemeIdsForUnit(vocabUnit)
  lexemes.flatMap(lex => hyginus.tokens.filter(t => t.matchesLexeme(lex)))
}


// outputs labelled lexeme paired with Pos
def addPos(vocabUnit: Int) = {
  val tkns = tokensForUnit(vocabUnit)
  tkns.map (t => {
    val labelled = LewisShort.label(t.analyses.head.lemmaId)
    val pos = t.analyses.head.posLabel
    pos match {
      case "gerundive" => ("verb", pos)
      case "gerund" => ("verb", pos)
      case "participle" => ("verb", pos)
      case "infinitive" => ("verb", pos)
      case "supine" => ("verb", pos)
      case _ => (labelled, pos)
    }

  }).distinct
}

def unitCoverage(vocabUnit: Int) = {
  val total = tokens.size
  val counts = tokensForUnit(vocabUnit).map(_.urn).distinct.size

  val unitCoverage = (counts * 1.0 / total) * 100
  val unitPct = BigDecimal(unitCoverage).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble
  (counts, unitPct)
}


def markdown(vocabUnit: Int): String = {
  val groups = addPos(vocabUnit).groupBy(_._2)
  val sections = groups.keySet.toVector.sorted
  val entries = vocabMapForUnit(vocabUnit)
  val body = for (section <- sections) yield {
    section  match {
      case "gerundive" => ""
      case "gerund" => ""
      case "participle" => ""
      case "infinitive" => ""
      case "supine" => ""

      case _ => {
        println("SECTION " + section)
        val items = groups(section).map( pr => {
          val lex = pr._1
          if (entries.keySet.contains(lex)) {
            "- " + entries(pr._1)
          } else {
            println("FAILED TO FIND ENTRY FOR " + lex)
            ""
          }
        })
        s"## ${section.capitalize}\n\n" + items.filter(_.nonEmpty).mkString("\n")
      }
    }
  }
  val coverageNumbers = unitCoverage(vocabUnit)
  val count = coverageNumbers._1
  val pct =  coverageNumbers._2
  val preface = s"With vocabulary items through this unit, you can recognize **${count}* words in Hyginus (or **${pct}%** of the text of the *Fabulae*.)"

  preface + "\n\n" + body.mkString("\n\n")
}





/*
val unitVocab = lexemeIdsForUnit(1)
val pos = addPos(unitVocab)
val posGrouped = pos.groupBy(_._2)

posGrouped("indeclinable")


def listEm(unitNum: Int) = {
  val unitVocab =   lexemeIdsForUnit(unitNum).distinct.filterNot(l => tempOmit.contains(l))
  val pos = addPos(unitVocab)
  val posGrouped = pos.groupBy(_._2)
  val posCovered = posGrouped.keySet
  posGrouped("indeclinable")
}
*/
