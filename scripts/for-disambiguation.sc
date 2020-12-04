// write out a bazillion files for each passage of Hyginus
// to use in manual disambiguation through observable nbs.
import scala.io.Source
import edu.holycross.shot.cite._
import edu.holycross.shot.tabulae._
import java.io.PrintWriter

val f = "data/hyginus/hyginus-latc.cex"


case class Record (
  urn: Cite2Urn,
  label: String,
  passage: CtsUrn,
  token: String,
  lexeme: String,
  form: Cite2Urn,
  category: String,
  sequence: Int
) {

  def url = s"https://lingualatina.github.io/texts/browsable/hyginus/${hyginusSectionId}/"

  def canonicalPassageId = passage.collapsePassageBy(1).passageComponent
  def hyginusSectionId = passage.collapsePassageBy(2).passageComponent
  def labelledLexeme = LewisShort.label("ls." + Cite2Urn(lexeme).objectComponent)

  def tsv : String = {
    val formLabel = try {
      ValidForm.labels(form.toString)
    } catch {
      case t: Throwable => ""
    }

    s"${url}\t${canonicalPassageId}\t${passage.passageComponent}\t${token}\t${formLabel}\t${labelledLexeme}"
  }
}

val lines = Source.fromFile(f).getLines.toVector
val recordOpts = lines.tail.map(l => {
  val fields = l.split("#").toVector
  if (fields.size < 8) {
    println("Too few columns in " + l)
    None
  } else {

    Some(Record(
      Cite2Urn(fields(0)),
      fields(1),
      CtsUrn(fields(2)),
      fields(3),
      fields(4),
      Cite2Urn(fields(5)), //form
      fields(6), //category
      fields(7).toInt)
    )
  }
})

val records = recordOpts.flatten

val grouped = records.groupBy(_.canonicalPassageId).toVector
val ordered = grouped.map{ case (s,v) => (s, v.sortBy(_.sequence))}
val clustered = ordered.map(_._2)

def printCex(records: Vector[Record], baseDir: String = "disambiguation/hyginus/") : Unit = {
  val section = records.head.canonicalPassageId
  val f = baseDir + section + ".tsv"
  val tsvData = records.map(_.tsv)
  val hdr = "url\tpassage\ttokenid\ttoken\tform\tlexeme\n"
  new PrintWriter(f){write(hdr + tsvData.mkString("\n"));close; }
  println("Data written to " + f)
}
