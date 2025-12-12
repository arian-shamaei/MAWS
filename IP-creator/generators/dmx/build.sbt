ThisBuild / version := "0.1.0"
ThisBuild / scalaVersion := "2.13.10"

lazy val chiselGroup = "edu.berkeley.cs"
lazy val chiselVersion = "3.5.6"

ThisBuild / scalacOptions ++= Seq("-deprecation", "-unchecked", "-feature", "-Ymacro-annotations")

ThisBuild / resolvers ++= Seq(
  Resolver.sonatypeRepo("snapshots"),
  Resolver.sonatypeRepo("releases"),
  Resolver.mavenCentral
)

lazy val root = (project in file("."))
  .settings(
    name := "dmx-generator",
    libraryDependencies ++= Seq(
      "org.scala-lang.modules" %% "scala-parser-combinators" % "2.1.1",
      chiselGroup %% "chisel3" % chiselVersion,
      compilerPlugin((chiselGroup % "chisel3-plugin" % chiselVersion).cross(CrossVersion.full))
    )
  )
