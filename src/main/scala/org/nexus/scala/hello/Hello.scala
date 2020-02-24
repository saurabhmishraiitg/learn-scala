package org.nexus.scala.hello

import com.typesafe.scalalogging.Logger

object Hello extends App {

  println("Hello Scala Again")
  //def main(args: Array[String]): Unit = println("Hello Scala")
  val logger = Logger("name")
  logger.info("Logging Done")
  logger.info("Logging Done Again")

}
