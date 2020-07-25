
// From citable corpus page: make a ctiable corpus
import edu.holycross.shot.cite._
import edu.holycross.shot.ohco2._

val url = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(url, cexHeader = true)
val chapter = corpus ~~ CtsUrn("urn:cts:latinLit:stoa1263.stoa001.hc:108a")

// From orthography and tokenizing page:  make a tokenizable corpus
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
val tokenizable = TokenizableCorpus(chapter, Latin23Alphabet)



// From morphology page:  make a parsed LatinCorpus
import edu.holycross.shot.latincorpus._
import edu.holycross.shot.tabulae._
import scala.io.Source
val fstUrl = "https://lingualatina.github.io/analysis/data/c108.fst"
val fstLines = Source.fromURL(fstUrl).getLines.toVector

val lat23orthography: MidOrthography = Latin23Alphabet
val latc = LatinCorpus.fromFstLines(chapter,lat23orthography, fstLines, strict=false)

val ls =  "urn:cite2:tabulae:ls.v1:"
val morph = "urn:cite2:tabulae:morphforms.v1:"
val abbrs = Vector(
  "abbr#full",
  s"ls#${ls}"
)
val umgr = UrnManager(abbrs)


//latc.citeCollectionLines(umgr)
