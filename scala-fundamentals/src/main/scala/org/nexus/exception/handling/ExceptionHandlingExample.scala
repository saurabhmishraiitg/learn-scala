package org.nexus.exception.handling

import com.typesafe.scalalogging.Logger

import java.io.FileInputStream

/**
 * A proposed way of exception handling in Scala
 */
object ExceptionHandlingExample extends App {

  // logger
  val logger: Logger = Logger("ExceptionHandlingExample")

  /**
   *
   * @param filePath filePath
   * @return Unit
   */
  def readFile(filePath: String) = {
    cleanly(new FileInputStream(filePath))(_.close) { fis =>
      Iterator.continually(fis.read).takeWhile(_ != -1).foreach(println)
    }
  }

  /**
   * !!! TO BE IMPLEMENTED !!!
   *
   * @param filePath filePath
   */
  def readClassPathFile(filePath: String) = {
    // TODO Implement !!!
  }

  /**
   * Cleanly Close resource
   *
   * @param resource
   * @param cleanup
   * @param code
   * @tparam A
   * @tparam B
   * @return
   */
  def cleanly[A, B](resource: => A)(cleanup: A => Unit)(code: A => B): Either[Exception, B] = {
    try {
      val r = resource
      try {
        Right(code(r))
      } finally {
        logger.info("Calling Cleanup")
        cleanup(r)
      }
    }
    catch {
      case e: Exception => logger.info(e.getMessage); Left(e)
    }
  }

}
