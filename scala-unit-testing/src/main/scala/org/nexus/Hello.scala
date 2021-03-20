package org.nexus

import com.typesafe.scalalogging.StrictLogging

/**
 * Hello Scala
 */
class Hello extends StrictLogging {
  //  val logger: Logger = Logger("Hello")

  def sampleMethod() = {
    println("Hello Scala")
    logger.info("There Scala")
  }

}
