import scala.io.Source
import edu.holycross.shot.ohco2._
import edu.holycross.shot.nomisma._

val textUrl = "https://raw.githubusercontent.com/neelsmith/hctexts/master/cex/ocre43k.cex"
val ocre = CorpusSource.fromUrl(textUrl, cexHeader = true)
val morphologyUrl = "https://raw.githubusercontent.com/neelsmith/hctexts/master/workfiles/ocre/ocre-fst.txt"
val fstLines = Source.fromURL(morphologyUrl).getLines.toVector

import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._
val ocreOrtho: MidOrthography = Latin24Alphabet
val corpus = LatinCorpus.fromFstLines(
  ocre,
  ocreOrtho,
  fstLines,
  strict=false
)
