name := "learn-scala"
version := "0.1.0-SNAPSHOT"
// scalaVersion := "2.12.8"
scalaVersion := "2.11.8"
// scalaVersion := "2.13.1"
organization := "org.nexus"

//https://stackoverflow.com/questions/29065603/complete-scala-logging-example/32003907#32003907
libraryDependencies += "com.typesafe.scala-logging" %% "scala-logging" % "3.9.0"
libraryDependencies += "ch.qos.logback" % "logback-classic" % "1.2.3"

//https://medium.com/airframe/airframe-log-a-modern-logging-library-for-scala-56fbc2f950bc
//libraryDependencies += "org.wvlet.airframe" %% "airframe-log" % "19.7.3"
