package org.nexus.common

import java.io.FileReader
import java.nio.file.{Files, Paths}
import java.util.Properties

/**
  * This class will help pull out necessary configuration attributes from a local text file.
  * Adhoc approach to decouple sensitive configuration information from the GIT code base.
  */
object ConfigurationManager {

  /**
    * To make life simpler, we will expect the file to be present in the user's HOME location
    * File name local-ccm.prop
    * Data addition to the file will be manual
    * Configuration entries in the file will be key-value based
    * Benefit of this approach over any other complex Central Configuration Management, is in terms of
    * having no external dependency
    */

  // Get the file location and check if the file exists or not.
  val ccmFilePath = sys.env("HOME") + "/local-ccm.prop"

  /*
  Check if the CCM file exists or not. If not, then create an empty file.
   */
  def checkAndCreateIfNotExists(): Unit = {
    if (!Files.exists(Paths.get(ccmFilePath))) Files.createFile(Paths.get(ccmFilePath))
  }

  /*
  Get the value corresponding to the key.
   */
  def getConfiguration(keyName: String): String = {
    checkAndCreateIfNotExists

    // Load the CCM file
    val properties = new Properties()
    properties.load(new FileReader(ccmFilePath))

    // Get the property value from the CCM file
    properties.getProperty(keyName)
  }

}
