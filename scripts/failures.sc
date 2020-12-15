// do some analysis
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
import java.io.PrintWriter
import edu.holycross.shot.tabulae._
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._


// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin23/hyginus.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)
val tcorpus = TokenizableCorpus(corpus, Latin23Alphabet)
