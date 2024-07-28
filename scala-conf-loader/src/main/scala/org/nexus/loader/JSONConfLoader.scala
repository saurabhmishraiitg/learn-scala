package org.nexus.loader

import java.io.File

import com.typesafe.config.ConfigFactory

/**
  * Parse and read a JSON-type conf file.
  * In case file path is not provided, then try to load the ~/nexus.conf file
  * In case no header info is provided, then use org.nexus as the parentHeader
  *
  * ref : https://medium.com/@ramkarnani24/reading-configurations-in-scala-f987f839f54d
  */
class JSONConfLoader(val configFileLoc: String = System.getenv("HOME") + "/nexus.conf",
                     val parentHeader: String = "org.nexus") {

  // Sample Config Structure
  /*  com.ram.batch {
      spark {
        app-name = "my-app"
        master = "local"
        log-level = "INFO"
      }
      mysql {
        url = "jdbc:mysql://localhost/ram" // Ignore PORT if its 3306
        username = "root"
        password = "mysql"
      }
    }*/

  /**
    * In case no header is provided then use the default header
    *
    * @param childHeader
    * @param key
    * @return
    */
  def getConfig(childHeader: String = "default", key: String) = {
    // We are not attempting to optimize it by loading the file once and keeping in the memory.
    // Instead, everytime the method is called, we will try to load the file afresh.
    val config = ConfigFactory.parseFile(new File(configFileLoc)).getConfig(parentHeader).getConfig(childHeader)
    config.getString(key)
  }

  /**
    * Use this method if the config file is stored in the resources folder of the code classpath.
    *
    * In case no header is provided then use the default header.
    */
  def getLocalResourcesConfig(childHeader: String = "default", key: String) = {
    val config = ConfigFactory.load(configFileLoc).getConfig(parentHeader).getConfig(childHeader)
    config.getString(key)
  }
}

/**
  * Validate the methods of the JSONConfLoader Class.
  */
object JSONConfLoaderTest extends App {
  // Testing the Absolute Path Config file load.
  val config = new JSONConfLoader()
  println(config.getConfig(key = "whoami"))

  // Testing the Local config file load.
  val localConfig = new JSONConfLoader("application.conf")
  println(localConfig.getLocalResourcesConfig("scala-conf-loader", "log-level"))
}
