/*

libraryDependencies ++= Seq(
  "edu.holycross.shot.cite" %% "xcite" % "4.3.0",
  "edu.holycross.shot" %% "ohco2" % "10.20.4",
  //"edu.holycross.shot" %% "midvalidator" % "13.3.1",

  "edu.holycross.shot.mid" %% "orthography" % "2.1.0",

  "edu.holycross.shot" %% "latphone" % "3.0.0",
  "edu.holycross.shot" %% "latincorpus" % "2.2.2",
  "edu.holycross.shot" %% "tabulae" % "6.0.1",
)
*/
lazy val scala211 = "2.11.12"
lazy val scala212 = "2.12.10"
lazy val supportedScalaVersions = List(scala212, scala211)

ThisBuild / scalaVersion := scala212
ThisBuild / turbo := true

lazy val root = (project in file("."))
  .settings(
  resolvers += Resolver.jcenterRepo,
  libraryDependencies ++= Seq(
    "org.scalatest" %% "scalatest" % "3.1.2" % "test",
    "org.wvlet.airframe" %% "airframe-log" % "20.5.2",
    "edu.holycross.shot.cite" %% "xcite" % "4.3.0",
    "edu.holycross.shot" %% "ohco2" % "10.20.4",
    "edu.holycross.shot.mid" %% "orthography" % "2.1.0",
    "edu.holycross.shot" %% "latphone" % "3.0.0",
    "edu.holycross.shot" %% "tabulae" % "6.3.0",
    "edu.holycross.shot" %% "latincorpus" % "3.2.0"
  )
)


lazy val docs = project
    .in(file("docs-build"))
    .dependsOn(root)
    .enablePlugins(MdocPlugin)
    .settings(
      mdocIn := file("docs-src"),
      mdocOut := file("docs"),
      mdocExtraArguments := Seq("--no-link-hygiene")
    )
