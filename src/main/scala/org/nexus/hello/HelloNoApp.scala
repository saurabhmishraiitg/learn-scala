package org.nexus.hello

object HelloNoApp {

  def main(args: Array[String]): Unit = {
    println("Hello Scala without App")
    println(s"Arguments passed to function ${args.mkString(";")} ")
  }

}
