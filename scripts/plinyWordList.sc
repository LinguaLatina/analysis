// Composite of subpages of complete example, so you can Load
// and run in a console
import edu.holycross.shot.ohco2._
import edu.holycross.shot.cite._
import java.io.PrintWriter
import edu.holycross.shot.tabulae._
import edu.holycross.shot.mid.orthography._
import edu.holycross.shot.latin._
import edu.holycross.shot.latincorpus._


// Load citable corpus
val textUrl = "https://raw.githubusercontent.com/LinguaLatina/texts/master/texts/latin24/pliny-letters.cex"
val corpus = CorpusSource.fromUrl(textUrl, cexHeader = true)
val tcorpus = TokenizableCorpus(corpus, Latin24Alphabet)

val outfile = "pliny-wordlist.txt"
import java.io.PrintWriter

new PrintWriter(outfile){write(tcorpus.wordList.mkString("\n"));close;}
println("Wrote word list for Pliny to " + outfile)
