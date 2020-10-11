package org.nexus.hello

import com.typesafe.scalalogging.LazyLogging

object Hello extends App with LazyLogging {

  println("Hello Scala Again")
  //def main(args: Array[String]): Unit = println("Hello Scala")
  //  val logger = Logger("name")
  logger.info("Logging Done")
  logger.info("Logging Done Again")

}
