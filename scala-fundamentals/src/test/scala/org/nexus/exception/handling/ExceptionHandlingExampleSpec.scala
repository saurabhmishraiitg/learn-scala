package org.nexus.exception.handling

import com.typesafe.scalalogging.Logger
import org.scalatest.BeforeAndAfter
import org.scalatest.flatspec.AnyFlatSpec

class ExceptionHandlingExampleSpec extends AnyFlatSpec with BeforeAndAfter {

  // logger
  val logger: Logger = Logger("ExceptionHandlingExampleSpec")

  before {
    logger.info("Before starting the WorkflowControllerSpec")
  }

  "Exception handling" should "properly resolve exceptions raised" in {
    val filePath = "/Users/s0m0158/github/gg-gcp-common/README.md"
    ExceptionHandlingExample.readFile(filePath)
  }

  "Reading classPath file" should "properly return output" in {
    logger.info(System.getProperty("user.dir"))
  }

  after {
    logger.info("After completion of WorkflowControllerTest")
  }
}
