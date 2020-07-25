
// From citable corpus page:
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")

// From orthography and tokenizing page:
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)


import edu.holycross.shot.latincorpus._
import edu.holycross.shot.tabulae._
import scala.io.Source
val fstUrl = "https://lingualatina.github.io/analysis/data/c108.fst"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

val lat23orthogaphy: MidOrthography = Latin23Alphabet
val latc = LatinCorpus.fromFstLines(chapter,lat23orthogaphy, fstLines, strict=false)

val ls =  "urn:cite2:tabulae:ls.v1:"
val morph = "urn:cite2:tabulae:morphforms.v1:"
val abbrs = Vector(
  "abbr#full",
  s"ls#${ls}"
)
val umgr = UrnManager(abbrs)


def cexToken(tkn: LatinToken, umgr: UrnManager) : Vector[String] = {
  if (tkn.analyses.isEmpty) {
    Vector(Vector(tkn.urn,tkn.text,ls + "null", morph + "null").mkString("#"))
  } else {
    val lines = for (a <- tkn.analyses) yield {
      umgr.urn(a.lemmaId) match {
        case None => Vector(tkn.urn,tkn.text,ls + "null", a.formUrn).mkString("#")
        case Some(u) => Vector(tkn.urn,tkn.text,u,a.formUrn).mkString("#")
      }
    }
    lines
  }
}

val cexLines = latc.tokens.map(t => cexToken(t, umgr))


import java.time.LocalDate
import java.time.format.DateTimeFormatter
val formatter = DateTimeFormatter.ofPattern("yyyy_MM_dd")
val todayFormatted = LocalDate.now.format(formatter)

def makeCollection(collBase: String, cex: Vector[String]) = {
  val citable = for ( (ln, i) <- cex.zipWithIndex) yield {
    val recordId = todayFormatted + "_" + i
    val urnStr = collBase + recordId
    val label = "Record " + recordId
    urnStr + "#" + label + "#" + ln
  }
  citable
}
